require 'rails_helper'

feature 'Headhunter mark a candidate like a highlight' do
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

        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, 
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        login_as(headhunter, :scope => :headhunter)
        visit root_path
        click_on 'Vagas'
        click_on job_vacancy.heading
        click_on 'Lista Candidatos'

        page.find("##{registered.id}_candidatos").click


        expect(page).to have_content("Candidato #{registered.candidate.profile.name} marcado como destaque com sucesso")
        registered.reload
        expect(registered.highlight?).to eq(true) 
    end

    scenario 'and unchecked a candidate' do
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

        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, highlight: true, 
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        login_as(headhunter, :scope => :headhunter)
        visit root_path
        click_on 'Vagas'
        click_on job_vacancy.heading
        click_on 'Lista Candidatos'

        page.find("##{registered.id}_candidatos").click
        
        expect(page).to have_content("Candidato #{registered.candidate.profile.name} desmarcado como destaque com sucesso")
        registered.reload
        expect(registered.highlight?).to eq(false) 
    end

    scenario 'and checked a candidate from a list of candidate' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')
        
        first_candidate = Candidate.create!(email: 'first_candidate@teste.com',
                                            password: '123teste')
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Fulano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: first_candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        second_candidate = Candidate.create!(email: 'second_candidate@teste.com',
                                            password: '123teste')
        profile = Profile.create!(name: 'Siclano Moreira', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: second_candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')
                            
        third_candidate = Candidate.create!(email: 'third_candidate@teste.com',
                                            password: '123teste')
        profile = Profile.create!(name: 'Beltrano de Oliveira', social_name: 'Beltrano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: third_candidate.id)
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

        first_registered = Registered.create!(candidate_id: first_candidate.id, job_vacancy_id: job_vacancy.id, 
                                              registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        second_registered = Registered.create!(candidate_id: second_candidate.id, job_vacancy_id: job_vacancy.id, 
                                              registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        third_registered = Registered.create!(candidate_id: third_candidate.id, job_vacancy_id: job_vacancy.id, 
                                              registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        login_as(headhunter, :scope => :headhunter)
        visit root_path
        click_on 'Vagas'
        click_on job_vacancy.heading
        click_on 'Lista Candidatos'

        page.find("##{second_registered.id}_candidatos").click
        
        expect(page).to have_content("Candidato #{second_registered.candidate.profile.name} marcado como destaque com sucesso")
        second_registered.reload
        expect(second_registered.highlight?).to eq(true) 
    end

    scenario 'and unchecked a candidate from a list of candidate' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')
        
        first_candidate = Candidate.create!(email: 'first_candidate@teste.com',
                                            password: '123teste')
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Fulano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: first_candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        second_candidate = Candidate.create!(email: 'second_candidate@teste.com',
                                            password: '123teste')
        profile = Profile.create!(name: 'Siclano Moreira', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: second_candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')
                            
        third_candidate = Candidate.create!(email: 'third_candidate@teste.com',
                                            password: '123teste')
        profile = Profile.create!(name: 'Beltrano de Oliveira', social_name: 'Beltrano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: third_candidate.id)
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

        first_registered = Registered.create!(candidate_id: first_candidate.id, job_vacancy_id: job_vacancy.id, 
                                              registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        second_registered = Registered.create!(candidate_id: second_candidate.id, job_vacancy_id: job_vacancy.id, highlight: true,
                                              registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        third_registered = Registered.create!(candidate_id: third_candidate.id, job_vacancy_id: job_vacancy.id, 
                                              registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        login_as(headhunter, :scope => :headhunter)
        visit root_path
        click_on 'Vagas'
        click_on job_vacancy.heading
        click_on 'Lista Candidatos'

        page.find("##{second_registered.id}_candidatos").click
        
        expect(page).to have_content("Candidato #{second_registered.candidate.profile.name} desmarcado como destaque com sucesso")
        second_registered.reload
        expect(second_registered.highlight?).to eq(false) 
    end

end