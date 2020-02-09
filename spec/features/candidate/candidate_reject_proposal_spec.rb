# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate reject a proposal' do
  scenario 'successfully' do
    profile = create(:profile, :with_photo, name: 'Fulano de Tal')
    candidate = profile.candidate
    registered = create(:registered, candidate: candidate,
                                     status: :proposal)
    proposal = create(:proposal, registered: registered)

    login_as(candidate, scope: :candidate)

    visit root_path
    click_on 'Minhas propostas'
    click_on 'Analisar proposta'
    click_on 'Rejeitar proposta'

    fill_in 'Feedback', with: 'Não concordo com o salario oferecido.'

    click_on 'Enviar'

    expect(page).to have_content(
      'Proposta rejeitada pelo candidato Fulano de Tal,'\
        ' feedback sera enviado ao headhunter'
    )

    registered.reload
    proposal.reload

    expect(registered.status).to eq('reject_proposal')
    expect(proposal.status).to eq('rejected')
    expect(proposal.feedback).to eq('Não concordo com o salario oferecido.')
  end

  scenario 'and no fill feedback' do
    profile = create(:profile, :with_photo, name: 'Fulano de Tal')
    candidate = profile.candidate
    registered = create(:registered, candidate: candidate,
                                     status: :proposal)
    proposal = create(:proposal, registered: registered)

    login_as(candidate, scope: :candidate)

    visit root_path
    click_on 'Minhas propostas'
    click_on 'Analisar proposta'
    click_on 'Rejeitar proposta'
    click_on 'Enviar'

    expect(page).to have_content(
      'Proposta rejeitada pelo candidato Fulano de Tal,'\
      ' feedback sera enviado ao headhunter'
    )

    registered.reload
    proposal.reload

    expect(registered.status).to eq('reject_proposal')
    expect(proposal.status).to eq('rejected')
    expect(proposal.feedback).to eq('Proposta rejeitada pelo candidato')
  end

  scenario 'and try to reject a proposal from another candidate' do
    first_profile = create(:profile, :with_photo, name: 'Fulano de Tal')
    first_candidate = first_profile.candidate

    second_profile = create(:profile, :with_photo, name: 'Siclano da Silva')
    second_candidate = second_profile.candidate

    job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby')

    create(:registered, candidate: first_candidate,
                        job_vacancy: job_vacancy,
                        status: :proposal)

    second_registered = create(:registered, candidate: second_candidate,
                                            job_vacancy: job_vacancy,
                                            status: :proposal)

    proposal = create(:proposal, registered: second_registered)

    login_as(first_candidate, scope: :candidate)

    visit reject_proposal_path(proposal)

    expect(current_path).to eq(root_path)
  end

  context 'route access test' do
    scenario 'a no-authenticate usser try to rejected proposal option' do
      proposal = create(:proposal)

      visit reject_proposal_path(proposal)

      expect(current_path).to eq(new_candidate_session_path)
    end
  end
end
