require 'rails_helper'

feature 'Headhunter rejects a candidate' do
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

        page.find("##{registered.id}_canceled").click

        fill_in 'Feedback', with: 'Candidato foi encerrado devido não ter todas as habilidades necessarias.'
        
        click_on 'Encerrar'

        expect(page).to have_content("Candidato #{profile.name} teve sua participação finalizada com sucesso")

        registered.reload

        expect(registered.status).to eq('closed')
        expect(page).to have_content("Feedback:#{registered.closed_feedback}")
    end

    scenario 'and try to closed a registered without fill justification' do
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
        page.find("##{registered.id}_canceled").click
        
        click_on 'Encerrar'

        expect(page).to have_content('Campo Feedback não pode ser vazio')
        expect(registered.status).to eq('in_progress')
    end
end
