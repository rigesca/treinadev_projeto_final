require 'rails_helper'

feature 'Headhunter list candidates from a vacancy' do
    scenario 'successfully' do
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
                                         headhunter_id: headhunter.id)


        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id,
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        login_as(headhunter, :scope => :headhunter)

        visit root_path
        click_on 'Vagas'
        click_on job_vacancy.heading
        click_on 'Lista Candidatos'

        expect(page).to have_content("#{profile.name} - #{profile.calculates_candidate_age}")
        expect(page).to have_content(registered.registered_justification)
    end

    scenario 'and has many candidates' do
        candidate_1 = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')

        profile_1 = Profile.create!(name: 'Fulano Da Silva', social_name: 'Beltrano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate_1.id)

        profile_1.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        candidate_2 = Candidate.create!(email: 'candidate2@teste.com',
                                      password: '123teste')

        profile_2 = Profile.create!(name: 'Siclano Alves', social_name: 'Fulano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate_2.id)

        profile_2.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        candidate_3 = Candidate.create!(email: 'candidate3@teste.com',
                                      password: '123teste')

        profile_3 = Profile.create!(name: 'Beltrano Carvalho', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate_3.id)

        profile_3.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
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
                                         headhunter_id: headhunter.id)


        registered_1 = Registered.create!(candidate_id: candidate_1.id, job_vacancy_id: job_vacancy.id,
                                          registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        
        registered_2 = Registered.create!(candidate_id: candidate_2.id, job_vacancy_id: job_vacancy.id,
                                          registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        registered_3 = Registered.create!(candidate_id: candidate_3.id, job_vacancy_id: job_vacancy.id,
                                          registered_justification: 'Estou preparado para exercer esse cargo na empresa')    

        login_as(headhunter, :scope => :headhunter)

        visit job_vacancy_path(job_vacancy)
        click_on 'Lista Candidatos'

        expect(page).to have_content("#{profile_1.name} - #{profile_1.calculates_candidate_age}")
        expect(page).to have_content(registered_1.registered_justification)

        expect(page).to have_content("#{profile_2.name} - #{profile_1.calculates_candidate_age}")
        expect(page).to have_content(registered_2.registered_justification)

        expect(page).to have_content("#{profile_3.name} - #{profile_1.calculates_candidate_age}")
        expect(page).to have_content(registered_3.registered_justification)
    end

    scenario 'and has no registered candidates' do
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
                                         headhunter_id: headhunter.id)

        login_as(headhunter, :scope => :headhunter)

        visit candidate_list_job_vacancy_path(job_vacancy.id)

        expect(page).to have_content('A vaga não possui candidatos em destaque.')
    end

    scenario 'and has no favorit registered candidates' do
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

        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, 
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        login_as(headhunter, :scope => :headhunter)
        visit candidate_list_job_vacancy_path(job_vacancy.id)

        expect(page).to have_content('A vaga não possui candidatos em destaque.') 
    end

    scenario 'and has no canceled registered' do
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

        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, 
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        login_as(headhunter, :scope => :headhunter)
        visit candidate_list_job_vacancy_path(job_vacancy.id)

        expect(page).to have_content('A vaga não possui candidatos recusados.') 
    end



    context 'route access test' do
        scenario 'a no-authenticate usser try to access candidate list option' do
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
            
            visit candidate_list_job_vacancy_path(job_vacancy)

            expect(current_path).to eq(new_headhunter_session_path)
        end
    end
end