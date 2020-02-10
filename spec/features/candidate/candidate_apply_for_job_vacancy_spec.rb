# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate apply for a job vacancy' do
  scenario 'successfully' do
    candidate = create(:profile, :with_photo).candidate

    create(:job_vacancy, title: 'Vaga de Ruby',
                         level: :trainee)

    login_as(candidate, scope: :candidate)

    visit root_path

    click_on 'Busca por vagas'
    click_on 'Estágiario | Vaga de Ruby'
    fill_in 'Justificativa', with: 'Estou preparado para a vaga.'
    click_on 'Candidatar-se a vaga'

    expect(page).to have_content(
      'Você se escreveu para a vaga: Vaga de Ruby, com sucesso'
    )
    expect(page).not_to have_button('Candidatar-se a vaga')
  end

  scenario 'try to apply for a vacancy without filling in the justification' do
    candidate = create(:profile, :with_photo).candidate
    job_vacancy = create(:job_vacancy)

    login_as(candidate, scope: :candidate)

    visit job_vacancies_path
    click_on job_vacancy.heading
    click_on 'Candidatar-se a vaga'

    expect(page).to have_content('Justificativa não pode ficar em branco')
    expect(page).to have_button('Candidatar-se a vaga')
  end

  scenario 'try to apply for a vacancy you already applying for' do
    candidate = create(:profile, :with_photo).candidate
    job_vacancy = create(:job_vacancy)
    create(:registered, candidate: candidate, 
                        job_vacancy: job_vacancy)

    login_as(candidate, scope: :candidate)

    visit job_vacancies_path

    click_on job_vacancy.heading

    expect(page).not_to have_button('Candidatar-se a vaga')
    expect(page).to have_content(
      'Você já se encontra inscrito para essa vaga.'
    )
  end
end
