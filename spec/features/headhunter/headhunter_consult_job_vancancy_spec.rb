# frozen_string_literal: true

require 'rails_helper'

feature 'Headhunter consults job vancancy' do
  scenario 'successfully' do
    headhunter = create(:headhunter)
    job = create(:job_vacancy, title: 'Vaga de Ruby',
                               vacancy_description: 'O profissional ira '\
                               ' trabalhar com ruby',
                               ability_description: 'Conhecimento em '\
                               ' TDD e Ruby',
                               level: :junior,
                               limit_date: 7.days.from_now,
                               region: 'Av.Paulista, 1000',
                               minimum_wage: 2500,
                               maximum_wage: 2800,
                               headhunter_id: headhunter.id)

    login_as(headhunter, scope: :headhunter)

    visit root_path

    click_on 'Vagas'
    click_on job.title

    expect(page).to have_content('Vaga de Ruby')
    expect(page).to have_content('O profissional ira trabalhar com ruby')
    expect(page).to have_content('Conhecimento em TDD e Ruby')
    expect(page).to have_content('Júnior')
    expect(page).to have_content(I18n.l(7.days.from_now, format: '%d/%m/%Y'))
    expect(page).to have_content('Av.Paulista, 1000')
    expect(page).to have_content(number_to_currency(2500))
    expect(page).to have_content(number_to_currency(2800))
  end

  scenario 'and no have vancany' do
    headhunter = create(:headhunter)

    login_as(headhunter, scope: :headhunter)

    visit root_path

    click_on 'Vagas'

    expect(page).to have_content('Seu perfil não possui vagas cadastradas')
  end

  context 'route access test' do
    scenario 'a no-authenticate usser try to access show job vacancy option' do
      visit new_job_vacancy_path

      expect(current_path).to eq(new_headhunter_session_path)
    end
  end
end
