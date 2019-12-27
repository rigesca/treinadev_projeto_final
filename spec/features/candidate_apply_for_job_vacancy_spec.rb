require 'rails_helper'

feature 'Candidate apply for a job vacancy' do
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

        job_vacancy = JobVacancy.create!(title: 'Vaga de Ruby', 
                                         vacancy_description:'O profissional ira trabalhar com ruby',
                                         ability_description:'Conhecimento em TDD e ruby',
                                         level: :junior,
                                         limit_date: 7.day.from_now,
                                         region: 'Av.Paulista, 1000',
                                         minimum_wage: 2500,
                                         maximum_wage: 2800,
                                         headhunter_id: headhunter.id)

        login_as(candidate, :scope => :candidate)

        visit root_path
        click_on 'Busca por vagas'
        click_on job_vacancy.heading

        expect(current_path).to eq(job_vacancy_path(job_vacancy))

        fill_in 'Justificativa', with: 'Sou o candidato mais bem preparado para a vaga.'
        click_on 'Candidatar-se a vaga'

        expect(page).to have_content("Você se escreveu para a vaga: #{job_vacancy.title}, com sucesso")
        expect(page).not_to have_button('Candidatar-se a vaga')
    end

    scenario 'try to apply for a vacancy without filling in the justification' do
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

        job_vacancy = JobVacancy.create!(title: 'Vaga de Ruby', 
                                         vacancy_description:'O profissional ira trabalhar com ruby',
                                         ability_description:'Conhecimento em TDD e ruby',
                                         level: :junior,
                                         limit_date: 7.day.from_now,
                                         region: 'Av.Paulista, 1000',
                                         minimum_wage: 2500,
                                         maximum_wage: 2800,
                                         headhunter_id: headhunter.id)

        login_as(candidate, :scope => :candidate)

        visit job_vacancies_path
        click_on job_vacancy.heading

        click_on 'Candidatar-se a vaga'

        expect(page).to have_content('Justificativa não pode ficar em branco')
        expect(page).to have_button('Candidatar-se a vaga')
    end

    scenario 'try to apply for a vacancy you already applying for' do
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

        login_as(candidate, :scope => :candidate)

        visit job_vacancies_path

        click_on job_vacancy.heading

        expect(page).not_to have_button('Candidatar-se a vaga')
        expect(page).to have_content('Você já se encontra inscrito para essa vaga.')
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
end