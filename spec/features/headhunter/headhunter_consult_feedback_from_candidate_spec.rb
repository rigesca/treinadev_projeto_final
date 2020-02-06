# frozen_string_literal: true

require 'rails_helper'

feature 'Headhunter consult feedback from candidate' do
  scenario 'from a accepted proposal' do
    headhunter = create(:headhunter)
    profile = create(:profile)
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy,
                                     status: :accept_proposal)
    create(:proposal, status: :accepted,
                      feedback: 'Obrigado pela oportunidade.',
                      registered_id: registered.id)

    login_as(headhunter, scope: :headhunter)

    visit root_path

    click_on 'Propostas'
    click_on 'Analisar proposta'

    expect(page).to have_content('Proposta Aceita')
    expect(page).to have_content(
      'Feedback candidato: Obrigado pela oportunidade'
    )
  end

  scenario 'from a rejected proposal' do
    headhunter = create(:headhunter)
    profile = create(:profile)
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy,
                                     status: :reject_proposal)
    create(:proposal, status: :rejected,
                      feedback: 'Obrigado pela oportunidade, porem já '\
                      'aceitei outra proposta.',
                      registered_id: registered.id)

    login_as(headhunter, scope: :headhunter)

    visit root_path

    click_on 'Propostas'
    click_on 'Analisar proposta'

    expect(page).to have_content('Proposta Rejeitada')
    expect(page).to have_content(
      'Feedback candidato: Obrigado pela oportunidade,'\
      ' porem já aceitei outra proposta.'
    )
  end
end
