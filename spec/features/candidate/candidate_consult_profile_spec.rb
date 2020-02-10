# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate consults your profile' do
  scenario 'successfully' do
    profile = create(:profile, :with_photo,
                     name: 'Fulano da Silva',
                     social_name: 'Siclano',
                     birth_date: '10/08/2000',
                     formation: 'Formado em analise de sistema pela '\
                     'faculdade UniAlgumaCoisa.',
                     description: 'Sou talentoso!',
                     experience: 'Trabalhou 5 anos na empresa Z como '\
                     'programador ruby.')

    login_as(profile.candidate, scope: :candidate)

    visit root_path
    click_on 'Perfil'

    expect(page).to have_content('Fulano da Silva')
    expect(page).to have_content('Siclano')
    expect(page).to have_content('10/08/2000')
    expect(page).to have_content(
      'Formado em analise de sistema pela faculdade UniAlgumaCoisa.'
    )
    expect(page).to have_content('Sou talentoso!')
    expect(page).to have_content(
      'Trabalhou 5 anos na empresa Z como programador ruby.'
    )
  end

  scenario 'successfully and go back to root' do
    candidate = create(:profile, :with_photo).candidate

    login_as(candidate, scope: :candidate)

    visit root_path
    click_on 'Perfil'
    click_on 'Voltar'

    expect(current_path).to eq(root_path)
  end

  context 'route access test' do
    scenario 'a no-authenticate usser try to access edit profile option' do
      profile = create(:profile, :with_photo)

      visit edit_profile_path(profile)

      expect(current_path).to eq(new_candidate_session_path)
    end

    scenario 'a no-authenticate usser try to access show profile option' do
      profile = create(:profile, :with_photo)

      visit profile_path(profile)

      expect(current_path).to eq(root_path)
    end
  end
end
