require 'rails_helper'

feature 'Candidate consult job vacancy' do
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

        login_as(candidate, :scope => :candidate)

        visit root_path

        click_on 'Busca por vagas'
        click_on job_vacancy.heading

        expect(page).to have_content(job_vacancy.title)
        expect(page).to have_content(job_vacancy.vacancy_description)
        expect(page).to have_content(job_vacancy.ability_description)
        expect(page).to have_content(I18n.t(job_vacancy.level, scope: [:enum,:levels]))
        expect(page).to have_content(I18n.localize job_vacancy.limit_date)
        expect(page).to have_content(job_vacancy.region)
        expect(page).to have_content(number_to_currency job_vacancy.minimum_wage)
        expect(page).to have_content(number_to_currency job_vacancy.maximum_wage)
        expect(page).to have_content(I18n.t(job_vacancy.status, scope: [:enum,:statuses]))
        expect(page).to have_content('Justificativa')
    end

end