require 'rails_helper'

feature 'Candidate search for a job vacancy' do

    context 'vacancies screen' do
        scenario 'and have some valide vacancies'do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                          password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            login_as(candidate, :scope => :candidate)
            visit root_path
            click_on 'Busca por vagas'

            expect(page).to have_content(job_vacancy_1.heading)
            expect(page).to have_content(job_vacancy_2.heading)
        end

        scenario 'and no have vacancy' do
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
    
            visit job_vacancies_path
    
            expect(page).to have_content('Não existem vagas abertas no momento')
        end
    
        scenario 'and have a closed vacancy' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                          password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                           filename:'foto.jpeg')
    
            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')
    
            job_vacancy = JobVacancy.create!(title: 'Vaga de Ruby', 
                                             vacancy_description:'O profissional ira trabalhar com ruby',
                                             ability_description:'Conhecimento em TDD e ruby',
                                             level: :junior,
                                             limit_date: 7.day.from_now,
                                             region: 'Av.Paulista, 1000',
                                             minimum_wage: 2500,
                                             maximum_wage: 2800,
                                             status: :closed,
                                             headhunter_id: headhunter.id)
    
            login_as(candidate, :scope => :candidate)
    
            visit job_vacancies_path
    
            expect(page).to have_content('Não existem vagas abertas no momento')
        end
    end



    context 'only a title'do
        scenario 'successfully' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :manager,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path

            fill_in 'Titulo', with: 'fullstack'

            click_on 'Pesquisar'

            expect(page).to have_content(job_vacancy_3.heading)
            expect(page).not_to have_content(job_vacancy_2.heading)
            expect(page).not_to have_content(job_vacancy_1.heading)
            expect(page).not_to have_content(job_vacancy_4.heading)
        end

        scenario 'multiples results' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :manager,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path

            fill_in 'Titulo', with: 'desen'

            click_on 'Pesquisar'

            expect(page).to have_content(job_vacancy_1.heading)
            expect(page).to have_content(job_vacancy_2.heading)
            expect(page).not_to have_content(job_vacancy_3.heading)
            expect(page).to have_content(job_vacancy_4.heading)
        end

        scenario 'no result' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :manager,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path

            fill_in 'Titulo', with: 'rails'

            click_on 'Pesquisar'

            expect(page).not_to have_content(job_vacancy_1.heading)
            expect(page).not_to have_content(job_vacancy_2.heading)
            expect(page).not_to have_content(job_vacancy_3.heading)
            expect(page).not_to have_content(job_vacancy_4.heading)
        end
    end



    context 'only level'do
        scenario 'successfully' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :manager,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path

            find("[value='junior']").set(true)

            click_on 'Pesquisar'

            expect(page).to have_content(job_vacancy_1.heading)
            expect(page).not_to have_content(job_vacancy_2.heading)
            expect(page).not_to have_content(job_vacancy_3.heading)            
            expect(page).not_to have_content(job_vacancy_4.heading)
        end

        scenario 'multiples results' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :manager,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path

            find("[value='full']").set(true)
            find("[value='specialist']").set(true)

            click_on 'Pesquisar'

            expect(page).not_to have_content(job_vacancy_1.heading)
            expect(page).to have_content(job_vacancy_2.heading)
            expect(page).to have_content(job_vacancy_3.heading)            
            expect(page).not_to have_content(job_vacancy_4.heading)
        end

        scenario 'no result' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path

            find("[value='trainee']").set(true)
            find("[value='senior']").set(true)

            click_on 'Pesquisar'

            expect(page).not_to have_content(job_vacancy_1.heading)
            expect(page).not_to have_content(job_vacancy_2.heading)
            expect(page).not_to have_content(job_vacancy_3.heading)            
            expect(page).not_to have_content(job_vacancy_4.heading)
        end
    end



    context 'only value'do
        scenario 'successfully' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :manager,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path

            fill_in 'Valor minimo', with: 5000

            click_on 'Pesquisar'

            expect(page).not_to have_content(job_vacancy_1.heading)
            expect(page).not_to have_content(job_vacancy_2.heading)
            expect(page).to have_content(job_vacancy_3.heading)            
            expect(page).not_to have_content(job_vacancy_4.heading)
        end

        scenario 'multiples results' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :manager,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path

            fill_in 'Valor minimo', with: 3700

            click_on 'Pesquisar'

            expect(page).not_to have_content(job_vacancy_1.heading)
            expect(page).not_to have_content(job_vacancy_2.heading)
            expect(page).to have_content(job_vacancy_3.heading)            
            expect(page).to have_content(job_vacancy_4.heading)
        end

        scenario 'no result' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path

            fill_in 'Valor minimo', with: 5500

            click_on 'Pesquisar'

            expect(page).not_to have_content(job_vacancy_1.heading)
            expect(page).not_to have_content(job_vacancy_2.heading)
            expect(page).not_to have_content(job_vacancy_3.heading)            
            expect(page).not_to have_content(job_vacancy_4.heading)
        end
    end




    context 'multiples search options'do
        scenario 'successfully' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :manager,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path

            fill_in 'Titulo', with: 'desen'
            find("[value='full']").set(true)
            fill_in 'Valor minimo', with: 2800

            click_on 'Pesquisar'

            expect(page).not_to have_content(job_vacancy_1.heading)
            expect(page).to have_content(job_vacancy_2.heading)
            expect(page).not_to have_content(job_vacancy_3.heading)            
            expect(page).not_to have_content(job_vacancy_4.heading)
        end

        scenario 'no results' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)
            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

            headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                            password: '123teste')

            job_vacancy_1 = JobVacancy.create!(title: 'Desenvolvedor Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_2 = JobVacancy.create!(title: 'Desenvolvedor Java', 
                                               vacancy_description:'O profissional ira trabalhar com java',
                                               ability_description:'Conhecimento em OO e java',
                                               level: :full,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1200',
                                               minimum_wage: 2800,
                                               maximum_wage: 3200,
                                               headhunter_id: headhunter.id)
            
            job_vacancy_3 = JobVacancy.create!(title: 'Analista Fullstack', 
                                               vacancy_description:'O profissional ira trabalhar varias linguagens',
                                               ability_description:'Conhecimento em varias linguagens',
                                               level: :specialist,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 5000,
                                               maximum_wage: 5800,
                                               headhunter_id: headhunter.id)
                                
            job_vacancy_4 = JobVacancy.create!(title: 'Gerente de projeto de desenvolvimento de software', 
                                               vacancy_description:'O profissional ira trabalhar com varios projetos',
                                               ability_description:'Conhecimento em vgerenciamento de projetos e metodologias ágeis',
                                               level: :manager,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Sapopenba, 200',
                                               minimum_wage: 3700,
                                               maximum_wage: 4200,
                                               headhunter_id: headhunter.id)

            login_as(candidate, :scope => :candidate)
            visit job_vacancies_path
            
            fill_in 'Titulo', with: 'Rails'
            find("[value='senior']").set(true)
            fill_in 'Valor minimo', with: 3500

            click_on 'Pesquisar'

            expect(page).not_to have_content(job_vacancy_1.heading)
            expect(page).not_to have_content(job_vacancy_2.heading)
            expect(page).not_to have_content(job_vacancy_3.heading)            
            expect(page).not_to have_content(job_vacancy_4.heading)
        end
    end    
end