require 'rails_helper'

feature 'Headhunter consults job vancancy' do
    scenario 'successfully' do
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

        visit root_path
        click_on 'Vagas'
        click_on job_vacancy.title

        expect(page).to have_content(job_vacancy.title)
        expect(page).to have_content(job_vacancy.vacancy_description)
        expect(page).to have_content(job_vacancy.ability_description)
        expect(page).to have_content(job_vacancy.level)
        expect(page).to have_content(I18n.localize job_vacancy.limit_date)
        expect(page).to have_content(job_vacancy.region)
        expect(page).to have_content(number_to_currency job_vacancy.minimum_wage)
        expect(page).to have_content(number_to_currency job_vacancy.maximum_wage)
    end

    scenario 'and no have vancany' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')
        
        login_as(headhunter, :scope => :headhunter)

        visit root_path
        click_on 'Vagas'
        
        expect(page).to have_content('Seu perfil não possui vagas cadastradas')
    end



    context 'route access test' do
        scenario 'a no-authenticate usser try to access show job vacancy option' do
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
            
            visit new_job_vacancy_path

            expect(current_path).to eq(new_headhunter_session_path)
        end
    end
    
end