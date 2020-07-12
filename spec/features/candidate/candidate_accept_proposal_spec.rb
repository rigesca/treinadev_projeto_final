# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate accepted a proposal' do
  scenario 'successfully' do
    candidate = create(:profile, :with_photo).candidate

    registered = create(:registered, candidate: candidate, status: :proposal)
    proposal = create(:proposal, registered: registered)

    login_as(candidate, scope: :candidate)

    visit root_path

    click_on 'Minhas propostas'
    click_on 'Analisar proposta'
    click_on 'Aceitar proposta'

    fill_in 'Feedback', with: 'Obrigado pela oportunidade'
    check('confirm')
    click_on 'Enviar'

    expect(page).to have_content('Proposta aceita com sucesso. Parabéns!')

    registered.reload
    proposal.reload

    expect(registered.status).to eq('accept_proposal')
    expect(proposal.status).to eq('accepted')
    expect(proposal.feedback).to eq('Obrigado pela oportunidade')
  end

  scenario 'and no fill feedback' do
    candidate = create(:profile, :with_photo).candidate

    registered = create(:registered, candidate: candidate, status: :proposal)
    proposal = create(:proposal, registered: registered)

    login_as(candidate, scope: :candidate)

    visit accept_proposal_path(proposal)

    check('confirm')

    click_on 'Enviar'

    expect(page).to have_content('Proposta aceita com sucesso. Parabéns!')

    registered.reload
    proposal.reload

    expect(registered.status).to eq('accept_proposal')
    expect(proposal.status).to eq('accepted')
    expect(proposal.feedback).to eq('Proposta aceita pelo candidato')
  end

  scenario 'and not confirm start date' do
    candidate = create(:profile, :with_photo).candidate

    registered = create(:registered, candidate: candidate, status: :proposal)
    proposal = create(:proposal, registered: registered)

    login_as(candidate, scope: :candidate)

    visit accept_proposal_path(proposal)

    fill_in 'Feedback', with: 'Obrigado pela oportunidade'

    click_on 'Enviar'

    expect(page).to have_content(
      'É necessario confirmar a data de inicio das atividades.'
    )
  end

  scenario 'and have multiples proposal and registered' do
    candidate = create(:profile, :with_photo).candidate

    registered_one = create(:registered, candidate: candidate,
                                         status: :proposal)
    accept_proposal = create(:proposal, registered: registered_one)

    registered_two = create(:registered, candidate: candidate,
                                         status: :proposal)
    create(:proposal, registered: registered_two)

    registered_three = create(:registered, candidate: candidate)

    login_as(candidate, scope: :candidate)

    visit accept_proposal_path(accept_proposal)

    check('confirm')
    click_on 'Enviar'

    expect(page).to have_content('Proposta aceita com sucesso. Parabéns!')

    registered_one.reload
    accept_proposal.reload

    expect(registered_one.status).to eq('accept_proposal')
    expect(accept_proposal.status).to eq('accepted')
    expect(accept_proposal.feedback).to eq('Proposta aceita pelo candidato')

    registered_two.reload

    expect(registered_two.status).to eq('reject_proposal')
    expect(registered_two.proposal).to eq(nil)

    registered_three.reload

    expect(registered_three.status).to eq('reject_proposal')
  end

  scenario 'and try to accept a proposal from another candidate' do
    first_candidate = create(:profile, :with_photo).candidate

    second_candidate = create(:profile, :with_photo).candidate
    second_candidate_registered = create(
      :registered, candidate: second_candidate,
                   status: :proposal
    )
    second_candidate_proposal = create(
      :proposal, registered: second_candidate_registered
    )

    login_as(first_candidate, scope: :candidate)

    visit accept_proposal_path(second_candidate_proposal)

    expect(current_path).to eq(root_path)
  end

  context 'route access test' do
    scenario 'a no-authenticate usser try to accepted proposal option' do
      proposal = create(:proposal)

      visit accept_proposal_path(proposal)

      expect(current_path).to eq(root_path)
    end
  end
end
