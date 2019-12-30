require 'rails_helper'

feature 'Candidate accepted a proposal'do
     
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
        click_on 'Aceitar proposta'
       
        expect(page).to have_content(I18n.localize proposal.start_date)
        fill_in 'Feedback', with: 'Obrigado pela oportunidade'
        check('confirm')
        
        click_on 'Enviar'

        expect(page).to have_content('Proposta aceita com sucesso. Parabéns!')

        registered.reload
        proposal.reload

        expect(registered.status).to eq('accept_proposal')
        expect(proposal.status).to eq('accepted')
        expect(proposal.feedback).to eq('Obrigado pela oportunidade')
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
        visit accept_proposal_path(proposal)
       
        expect(page).to have_content(I18n.localize proposal.start_date)
        check('confirm')
        
        click_on 'Enviar'

        expect(page).to have_content('Proposta aceita com sucesso. Parabéns!')

        registered.reload
        proposal.reload

        expect(registered.status).to eq('accept_proposal')
        expect(proposal.status).to eq('accepted')
        expect(proposal.feedback).to eq('Proposta aceita pelo candidato')
    end

    scenario 'and not confirm start date' do
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
        visit accept_proposal_path(proposal)
       
        expect(page).to have_content(I18n.localize proposal.start_date)
        fill_in 'Feedback', with: 'Obrigado pela oportunidade'
        
        click_on 'Enviar'

        expect(page).to have_content('É necessario confirmar a data de inicio das atividades.')
    end


    scenario 'and have multiples proposal and registered' do
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
        
        job_vacancy_1 = JobVacancy.create!(title: 'Vaga de Ruby', 
                                     vacancy_description:'O profissional ira trabalhar com ruby',
                                     ability_description:'Conhecimento em TDD e ruby',
                                     level: :junior,
                                     limit_date: 7.day.from_now,
                                     region: 'Av.Paulista, 1000',
                                     minimum_wage: 2500,
                                     maximum_wage: 2800,
                                     headhunter_id: headhunter.id)
        registered_1 = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy_1.id, status: :proposal,
                                    registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        proposal_1 = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7),
                                    salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered_1.id)
            
        job_vacancy_2 = JobVacancy.create!(title: 'Vaga de Java', 
                                     vacancy_description:'O profissional ira trabalhar com java',
                                     ability_description:'Conhecimento em OO e java',
                                     level: :junior,
                                     limit_date: 7.day.from_now,
                                     region: 'Av.Paulista, 1000',
                                     minimum_wage: 2500,
                                     maximum_wage: 2800,
                                     headhunter_id: headhunter.id)
        registered_2 = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy_2.id, status: :proposal,
                                    registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        proposal_2 = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7),
                                    salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered_2.id)

        job_vacancy_3 = JobVacancy.create!(title: 'Vaga de Java', 
                                     vacancy_description:'O profissional ira trabalhar com java',
                                     ability_description:'Conhecimento em OO e java',
                                     level: :junior,
                                     limit_date: 7.day.from_now,
                                     region: 'Av.Paulista, 1000',
                                     minimum_wage: 2500,
                                     maximum_wage: 2800,
                                     headhunter_id: headhunter.id)
        registered_3 = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy_2.id,
                                          registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        login_as(candidate, :scope => :candidate)
        visit accept_proposal_path(proposal_1)
       
        expect(page).to have_content(I18n.localize proposal_1.start_date)
        check('confirm')
        
        click_on 'Enviar'

        expect(page).to have_content('Proposta aceita com sucesso. Parabéns!')

        registered_1.reload
        proposal_1.reload

        expect(registered_1.status).to eq('accept_proposal')
        expect(proposal_1.status).to eq('accepted')
        expect(proposal_1.feedback).to eq('Proposta aceita pelo candidato')

        registered_2.reload
        proposal_2.reload

        expect(registered_2.status).to eq('reject_proposal')
        expect(proposal_2.status).to eq('rejected')
        expect(proposal_2.feedback).to eq('Candidato aceitou outra proposta')

        registered_3.reload

        expect(registered_3.status).to eq('reject_proposal')
    end
end