require 'rails_helper'

feature 'Candidate reject a proposal'do
     
    scenario 'successfully' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                    password: '123teste')
    
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                        password: '123teste')
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                              birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                              description: 'Busco oportunidade como programador',
                              experience: 'Trabalhou por 2 anos na empresa X',
                              candidate_id: candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                   filename:'foto.jpeg')
        job_vacancy = JobVacancy.create!(title: 'Vaga de Ruby', 
                                     vacancy_description:'O profissional ira trabalhar com ruby',
                                     ability_description:'Conhecimento em TDD e ruby',
                                     level: :junior,
                                     limit_date: 7.day.from_now,
                                     region: 'Av.Paulista, 1000',
                                     minimum_wage: 2500,
                                     maximum_wage: 2800,
                                     headhunter_id: headhunter.id)
        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :proposal,
                                    registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7),
                                    salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)
            
        login_as(candidate, :scope => :candidate)
        visit root_path
        click_on 'Minhas propostas'
        click_on 'Analisar proposta'
        click_on 'Rejeitar proposta'
       
        fill_in 'Feedback', with: 'Não concordo com o salario oferecido.'
        
        click_on 'Enviar'

        expect(page).to have_content("Proposta rejeitada pelo candidato #{profile.name}, feedback sera enviado ao headhunter")

        registered.reload
        proposal.reload

        expect(registered.status).to eq('reject_proposal')
        expect(proposal.status).to eq('rejected')
        expect(proposal.feedback).to eq('Não concordo com o salario oferecido.')
    end

    scenario 'and no fill feedback' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                    password: '123teste')
    
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                        password: '123teste')
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                              birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                              description: 'Busco oportunidade como programador',
                              experience: 'Trabalhou por 2 anos na empresa X',
                              candidate_id: candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                   filename:'foto.jpeg')
        job_vacancy = JobVacancy.create!(title: 'Vaga de Ruby', 
                                     vacancy_description:'O profissional ira trabalhar com ruby',
                                     ability_description:'Conhecimento em TDD e ruby',
                                     level: :junior,
                                     limit_date: 7.day.from_now,
                                     region: 'Av.Paulista, 1000',
                                     minimum_wage: 2500,
                                     maximum_wage: 2800,
                                     headhunter_id: headhunter.id)
        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :proposal,
                                    registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7),
                                    salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)
            
        login_as(candidate, :scope => :candidate)
        visit root_path
        click_on 'Minhas propostas'
        click_on 'Analisar proposta'
        click_on 'Rejeitar proposta'
        
        click_on 'Enviar'
        
        expect(page).to have_content("Proposta rejeitada pelo candidato #{profile.name}, feedback sera enviado ao headhunter")

        registered.reload
        proposal.reload

        expect(registered.status).to eq('reject_proposal')
        expect(proposal.status).to eq('rejected')
        expect(proposal.feedback).to eq('Proposta rejeitada pelo candidato')
    end
    
end