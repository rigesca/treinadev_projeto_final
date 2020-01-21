require 'rails_helper'

feature 'Headhunter consult feedback from candidate' do
    scenario 'from a accepted proposal' do
        headhunter = create(:headhunter)
        
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
        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :reject_proposal,
                                    registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), status: :rejected,
                                    salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id,
                                    feedback: 'Obrigado pela oportunidade, porem já estou negociando com outra empresa')
            
        login_as(headhunter, :scope => :headhunter)
        
        visit root_path
        
        click_on 'Propostas'
        click_on 'Analisar proposta'

        expect(page).to have_content("Proposta #{I18n.t(:rejected, scope: [:enum, :statuses])}")
        expect(page).to have_content("Feedback candidato: #{proposal.feedback}")
    end

    scenario 'from a rejected proposal' do
        headhunter = create(:headhunter)
        
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
        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :accept_proposal,
                                    registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), status: :accepted,
                                    salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id,
                                    feedback: 'Obrigado pela oportunidade')
            
        login_as(headhunter, :scope => :headhunter)
        
        visit root_path
        
        click_on 'Propostas'
        click_on 'Analisar proposta'

        expect(page).to have_content("Proposta #{I18n.t(:accepted, scope: [:enum, :statuses])}")
        expect(page).to have_content("Feedback candidato: #{proposal.feedback}")
    end
end