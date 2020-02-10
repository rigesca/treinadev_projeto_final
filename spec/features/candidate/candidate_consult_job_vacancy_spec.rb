# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate consult job vacancy' do
  scenario 'successfully' do
    candidate = create(:profile, :with_photo).candidate

    create(:job_vacancy, title: 'Vaga de Ruby',
                         vacancy_description: 'O profissional ira trabalhar'\
                         ' com ruby',
                         ability_description: 'Conhecimento em TDD e Ruby',
                         level: :full,
                         limit_date: 7.days.from_now,
                         region: 'Av.Paulista, 1000',
                         minimum_wage: 2500,
                         maximum_wage: 2800)

    login_as(candidate, scope: :candidate)

    visit root_path

    click_on 'Busca por vagas'
    click_on 'Pleno | Vaga de Ruby'

    expect(page).to have_content('Vaga de Ruby')
    expect(page).to have_content(
      'O profissional ira trabalhar com ruby'
    )
    expect(page).to have_content('Conhecimento em TDD e Ruby')
    expect(page).to have_content('Pleno')
    expect(page).to have_content(
      I18n.l(7.days.from_now, format: '%d/%m/%Y').to_s
    )
    expect(page).to have_content('Av.Paulista, 1000')
    expect(page).to have_content('R$ 2.500,00')
    expect(page).to have_content('R$ 2.800,00')
    expect(page).to have_content('Aberto')
    expect(page).to have_content('Justificativa')
  end
end
