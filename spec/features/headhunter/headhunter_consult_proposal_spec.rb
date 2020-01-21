require 'rails_helper'

feature 'headhunter consults a proposal' do
    context 'from proposal' do 
        scenario 'successfully' do 
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

            registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :proposal,
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

            proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7),
                                        salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)

            login_as(headhunter, :scope => :headhunter)

            visit root_path
            
            click_on 'Propostas'

            expect(page).to have_content("Proposta enviada para: #{profile.name}")
            expect(page).to have_content("Vaga : #{job_vacancy.heading}")
            expect(page).to have_content("Data limite para resposta: #{I18n.localize proposal.limit_feedback_date}")
            expect(page).to have_link("Analisar proposta")
            expect(page).to have_content("#{I18n.t(proposal.status, scope: [:enum, :statuses])}")
        end

        scenario 'and saw a proposal' do
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

            registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :proposal,
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

            proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7),
                                        salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)
                
            login_as(headhunter, :scope => :headhunter)

            visit root_path
            
            click_on 'Propostas'
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

        scenario 'and saw a reject proposal' do
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
                                        salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)
                
            login_as(headhunter, :scope => :headhunter)

            visit root_path
            
            click_on 'Propostas'
            
            expect(page).to have_content("Proposta enviada para: #{profile.name}")
            expect(page).to have_content("Vaga : #{job_vacancy.heading}")
            expect(page).to have_content("Data limite para resposta: #{I18n.localize proposal.limit_feedback_date}")
            expect(page).to have_link("Analisar proposta")
            expect(page).to have_content("#{I18n.t(:rejected, scope: [:enum, :statuses])}")
        end

        scenario 'and saw a accept proposal' do
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

            proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), status: :accepted,
                                        salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)
                
            login_as(headhunter, :scope => :headhunter)

            visit root_path
            
            click_on 'Propostas'
            
            expect(page).to have_content("Proposta enviada para: #{profile.name}")
            expect(page).to have_content("Vaga : #{job_vacancy.heading}")
            expect(page).to have_content("Data limite para resposta: #{I18n.localize proposal.limit_feedback_date}")
            expect(page).to have_link("Analisar proposta")
            expect(page).to have_content("#{I18n.t(:accepted, scope: [:enum, :statuses])}")
        end

        scenario 'and saw a expired proposal' do
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

            proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), status: :expired,
                                        salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)
                
            login_as(headhunter, :scope => :headhunter)

            visit root_path
            
            click_on 'Propostas'
            
            expect(page).to have_content("Proposta enviada para: #{profile.name}")
            expect(page).to have_content("Vaga : #{job_vacancy.heading}")
            expect(page).to have_content("Data limite para resposta: #{I18n.localize proposal.limit_feedback_date}")
            expect(page).to have_link("Analisar proposta")
            expect(page).to have_content("#{I18n.t(:expired, scope: [:enum, :statuses])}")
        end
    end



    context 'from vacancy' do 
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

            login_as(headhunter, :scope => :headhunter)

            visit root_path
            click_on 'Vagas'
            click_on job_vacancy.heading
            click_on 'Lista Candidatos'
            
            page.find("##{proposal.id}_show_proposal").click

            expect(page).to have_content(job_vacancy.heading)
            expect(page).to have_content("Descrição da vaga:#{job_vacancy.vacancy_description}")
            
            expect(page).to have_content(profile.name)
            
            expect(page).to have_content("Proposta #{I18n.t(proposal.status, scope: [:enum, :statuses])}")
            expect(page).to have_content("Data para inicio das atividades: #{I18n.localize proposal.start_date}")
            expect(page).to have_content("Data limite para resposta: #{I18n.localize proposal.limit_feedback_date}")
            expect(page).to have_content("Salário: #{number_to_currency proposal.salary}")
            expect(page).to have_content("Benefícios: #{proposal.benefits}")
        end
    end


    scenario 'and try to consult a proposal from another headhunter' do
            first_headhunter = Headhunter.create!(email: 'headhunter1@teste.com',
                                                  password: '123teste')

            second_headhunter = Headhunter.create!(email: 'headhunter2@teste.com',
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
                                         headhunter_id: first_headhunter.id)

            registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :proposal,
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

            proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7),
                                        salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)

            login_as(second_headhunter, :scope => :headhunter)

            visit proposal_path(proposal)

            expect(current_path).to eq(root_path)
    end
end
    