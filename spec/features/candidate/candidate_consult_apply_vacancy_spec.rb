# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate consults apply vacancy' do
  scenario 'successfully' do
    candidate = create(:profile, :with_photo).candidate
    job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                       level: :senior)

    create(:registered, candidate: candidate,
                        job_vacancy: job_vacancy)

    login_as(candidate, scope: :candidate)

    visit root_path
    click_on 'Minhas Vagas'
    click_on 'Sênior | Vaga de Ruby'

    expect(page).to have_content('Vaga de Ruby')
    expect(page).to have_content('Aberto')
    expect(page).to have_content('Você já se encontra inscrito para essa vaga.')
  end

  scenario 'without vacancy aplly' do
    candidate = create(:profile, :with_photo).candidate
    login_as(candidate, scope: :candidate)

    visit root_path
    click_on 'Minhas Vagas'

    expect(page).to have_content(
      'Você não possui nenhum inscrição em nenhuma vaga do site'
    )
  end

  scenario 'and be rejected' do
    candidate = create(:profile, :with_photo).candidate
    create(:registered, candidate: candidate,
                        status: :excluded,
                        closed_feedback: 'O candidato não apresenta todos os'\
                        ' requisitos necessarios')

    login_as(candidate, scope: :candidate)

    visit root_path
    click_on 'Minhas Vagas'

    expect(page).to have_content(
      'O candidato não apresenta todos os requisitos necessarios'
    )
    expect(page).to have_content('Candidatura Encerrada')
  end

  context 'route access test' do
    scenario 'a no-authenticate usser try to access index registered option' do
      visit registereds_path

      expect(current_path).to eq(root_path)
    end
  end
end
