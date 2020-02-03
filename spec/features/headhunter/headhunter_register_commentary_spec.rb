# frozen_string_literal: true

require 'rails_helper'

feature 'Headhunter register a commentary for a candidate' do
  scenario 'successfully' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    create(:registered, job_vacancy: job_vacancy,
                        candidate: profile.candidate)

    login_as(headhunter, scope: :headhunter)

    visit root_path

    click_on 'Vagas'
    click_on job_vacancy.heading
    click_on 'Lista Candidatos'
    click_on "#{profile.name} - #{profile.calculates_candidate_age}"
    click_on 'Comentários'

    fill_in 'Comentário', with: 'Boa tarde Fulano da Silva, gostamos muito do seu perfil.'
    click_on 'Envia comentário'

    commentary = Comment.last

    expect(page).to have_content(commentary.heading)
    expect(page).to have_content(
      'Boa tarde Fulano da Silva, gostamos muito do seu perfil.'
    )
    expect(page).to have_content(commentary.customized_send_time_message)
  end

  scenario 'and try to send a comentary without a text' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo)

    login_as(headhunter, scope: :headhunter)

    visit comments_list_profile_path(profile)
    click_on 'Envia comentário'

    expect(page).to have_content('Comentário não pode ficar em branco')
    expect(page).to have_content(
      'O candidato não possui comentários registrado em seu perfil.'
    )
  end

  scenario 'and headhunter cant see a commentary from another headhunter' do
    first_headhunter = create(:headhunter)
    second_headhunter = create(:headhunter)

    profile = create(:profile, :with_photo)

    create(
      :comment, headhunter: first_headhunter,
                profile_id: profile.id,
                comment: 'Olá, sou o Headhunter 1, entre em contato comigo!'
    )
    create(
      :comment, headhunter: second_headhunter,
                profile_id: profile.id,
                comment: 'Olá, sou o Headhunter 2, entre em contato comigo!'
    )

    login_as(first_headhunter, scope: :headhunter)

    visit comments_list_profile_path(profile)

    expect(page).to have_content(
      'Olá, sou o Headhunter 1, entre em contato comigo!'
    )
    expect(page).not_to have_content(
      'Olá, sou o Headhunter 2, entre em contato comigo!'
    )
  end

  context 'route access test' do
    scenario 'a no-authenticate usser try to access commentary list option' do
      profile = create(:profile)

      visit comments_list_profile_path(profile)

      expect(current_path).to eq(root_path)
    end
  end
end
