# frozen_string_literal: true

require 'rails_helper'

feature 'Headhunter register a commentary for a candidate' do
  scenario 'successfully' do
    headhunter = create(:headhunter, email: 'headhunter@gmail.com')

    profile = create(:profile, :with_photo, name: 'Fulano Da Silva')

    commentary = create(:comment, profile: profile, headhunter: headhunter,
                                  comment: 'Bom dia Fulano da Silva, '\
                                  'gostariamos de agendar uma entrevista '\
                                  'com você, entre em contato conosco.')

    login_as(profile.candidate, scope: :candidate)

    visit root_path
    click_on 'Perfil'
    click_on 'Comentários'

    expect(page).not_to have_button('Envia comentário')
    expect(page).to have_content('Headhunter: headhunter@gmail.com')
    expect(page).to have_content(
      'Bom dia Fulano da Silva, gostariamos de agendar uma entrevista com '\
      'você, entre em contato conosco'
    )
    expect(page).to have_content(
      "Enviada em: #{I18n.l(commentary.created_at, format: :long)}"
    )
  end

  scenario 'and see multiplos comments successfully' do
    profile = create(:profile, :with_photo)

    create(:comment, profile: profile,
                     comment: 'Primeiro comentário.')

    create(:comment, profile: profile,
                     comment: 'Segundo comentário.')

    create(:comment, profile: profile,
                     comment: 'Terceiro comentário.')

    login_as(profile.candidate, scope: :candidate)

    visit comments_list_profile_path(profile)

    expect(page).to have_content('Primeiro comentário.')
    expect(page).to have_content('Segundo comentário.')
    expect(page).to have_content('Terceiro comentário.')
  end

  scenario 'and no have commentary in your profile' do
    profile = create(:profile, :with_photo)

    login_as(profile.candidate, scope: :candidate)

    visit comments_list_profile_path(profile)

    expect(page).to have_content('O candidato não possui comentários '\
        'registrado em seu perfil.')
  end
end
