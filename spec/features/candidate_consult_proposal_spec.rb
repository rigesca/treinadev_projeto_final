require 'rails_helper'

feature 'Candidate consults a proposal'do
    context 'from my proposal' do 
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

            expect(page).to have_content("Proposta enviada por: #{headhunter.email}")
            expect(page).to have_content("Vaga : #{job_vacancy.heading}")
            expect(page).to have_content("Data limite para resposta: #{I18n.localize proposal.limit_feedback_date}")
            expect(page).to have_link("Analisar proposta")
        end

        scenario 'and saw the proposal' do
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

            expect(page).to have_content(job_vacancy.heading)
            expect(page).to have_content("Descrição da vaga:#{job_vacancy.vacancy_description}")
            
            expect(page).to have_content(profile.name)
            
            expect(page).to have_content("Proposta #{I18n.t(proposal.status, scope: [:enum, :statuses])}")
            expect(page).to have_content("Data para inicio das atividades: #{I18n.localize proposal.start_date}")
            expect(page).to have_content("Data limite para resposta: #{I18n.localize proposal.limit_feedback_date}")
            expect(page).to have_content("Salário: #{number_to_currency proposal.salary}")
            expect(page).to have_content("Benefícios: #{proposal.benefits}")
        end

        scenario 'and had a reject proposal' do
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

            registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :reject_proposal,
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

            proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), status: :rejected,
                                        salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)
                
            login_as(candidate, :scope => :candidate)

            visit proposals_path

            expect(page).not_to have_content("Proposta enviada por: #{headhunter.email}")
            expect(page).not_to have_content("Vaga : #{job_vacancy.heading}")
            expect(page).not_to have_content("Data limite para resposta: #{I18n.localize proposal.limit_feedback_date}")
            expect(page).not_to have_link("Analisar proposta")
        end

        scenario 'and no have proposal' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                            password: '123teste')

            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                           filename:'foto.jpeg')
                            
            login_as(candidate, :scope => :candidate)

            visit proposals_path

            expect(page).to have_content("Não existem propostas para seu perfil")   
        end

        
    end

    context 'from my job_vacancy' do 
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
            click_on 'Minhas Vagas'

            expect(page).to have_content(job_vacancy.heading)
            expect(page).to have_content("Descrição da vaga:#{job_vacancy.vacancy_description}")
            
            expect(page).to have_content('Proposta recebida !')
            expect(page).to have_link('Ver proposta')
        end

        scenario 'and saw the proposal' do
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
            click_on 'Minhas Vagas'
            click_on 'Ver proposta'

            expect(page).to have_content(job_vacancy.heading)
            expect(page).to have_content("Descrição da vaga:#{job_vacancy.vacancy_description}")
            
            expect(page).to have_content(profile.name)
            
            expect(page).to have_content("Proposta #{I18n.t(proposal.status, scope: [:enum, :statuses])}")
            expect(page).to have_content("Data para inicio das atividades: #{I18n.localize proposal.start_date}")
            expect(page).to have_content("Data limite para resposta: #{I18n.localize proposal.limit_feedback_date}")
            expect(page).to have_content("Salário: #{number_to_currency proposal.salary}")
            expect(page).to have_content("Benefícios: #{proposal.benefits}")
        end

        scenario 'and had a reject proposal' do
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

            registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :reject_proposal,
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

            proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), status: :rejected,
                                        salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)
                
            login_as(candidate, :scope => :candidate)

            visit registereds_path

            expect(page).to have_content(job_vacancy.heading)
            expect(page).to have_content("Proposta rejeitada")
            expect(page).to have_content("Feedback do candidato:#{proposal.feedback}")
        end
    end

    scenario 'and try to access a proposal from another candidate' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')
        
        first_candidate = Candidate.create!(email: 'candidate1@teste.com',
                                            password: '123teste')

        second_candidate = Candidate.create!(email: 'candidate2@teste.com',
                                            password: '123teste')

        first_profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: first_candidate.id)
        first_profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        second_profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: second_candidate.id)
        second_profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
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

        first_candidate_registered = Registered.create!(candidate_id: first_candidate.id, job_vacancy_id: job_vacancy.id, status: :proposal,
                                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        second_candidate_registered = Registered.create!(candidate_id: second_candidate.id, job_vacancy_id: job_vacancy.id, status: :proposal,
                                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7),
                                        salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: second_candidate_registered.id)
                
        login_as(first_candidate, :scope => :candidate)

        visit proposal_path(proposal)

        expect(current_path).to eq(root_path)
    end
end