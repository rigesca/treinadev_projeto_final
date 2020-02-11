# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate navigates homepage' do
  scenario 'successfully' do
    profile = create(:profile, :with_photo)
    login_as(profile.candidate, scope: :candidate)

    visit root_path

    expect(page).to have_content('Venha conhecer nossas vagas !')

    expect(page).to have_link('Perfil')
    expect(page).to have_link('Mensagens')
    expect(page).to have_link('Minhas Vagas')
    expect(page).to have_link('Busca por vagas')
    expect(page).to have_link('Minhas propostas')
  end

  scenario 'and have proposals' do
    profile = create(:profile, :with_photo)
    candidate = profile.candidate

    first_registered = create(:registered, candidate: candidate,
                                           status: :proposal)
    second_registered = create(:registered, candidate: candidate,
                                            status: :proposal)
    third_registered = create(:registered, candidate: candidate,
                                           status: :reject_proposal)

    create(:proposal, registered: first_registered)
    create(:proposal, registered: second_registered)
    create(:proposal, registered: third_registered, status: :rejected)

    login_as(candidate, scope: :candidate)

    visit root_path

    expect(page).to have_content(
      'Você possui (2) propostas não analisadas ainda.'
    )
  end
end
