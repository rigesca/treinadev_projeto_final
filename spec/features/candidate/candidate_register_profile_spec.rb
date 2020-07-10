# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate register a profile' do
  scenario 'successufully' do
    candidate = create(:candidate)
    login_as(candidate, scope: :candidate)

    visit root_path
    fill_in 'Nome completo', with: 'Fulano Siclano'
    fill_in 'Nome social', with: 'Siclano'
    fill_in 'Data de nascimento', with: '15/07/1989'
    attach_file 'Foto do candidato',
                Rails.root.join('spec/support/foto.jpeg')
    fill_in 'Formação', with: 'Graduado em analise de sistema'
    fill_in 'Descrição', with: 'Busco oportunidade como programador'
    fill_in 'Experiência', with: 'Trabalho 2 anos na empresa X'

    click_on 'Salvar'

    expect(page).to have_content('Perfil concluído com sucesso')
    expect(current_path).to eq(root_path)
  end

  scenario 'but incomplete profile' do
    candidate = create(:candidate)
    login_as(candidate, scope: :candidate)

    visit root_path
    fill_in 'Nome completo', with: 'Fulano Siclano'
    fill_in 'Data de nascimento', with: '15/07/1989'
    click_on 'Salvar'

    profile = Profile.last

    expect(page).to have_content(
      'É necessario completar o perfil para se inscrever em qualquer vaga'
    )
    expect(current_path).to eq(edit_profile_path(profile))
  end

  scenario 'and do not fill in the name and birth date' do
    candidate = create(:candidate)
    login_as(candidate, scope: :candidate)

    visit root_path
    click_on 'Salvar'

    expect(page).to have_content('Nome completo não pode ficar em branco')
    expect(page).to have_content(
      'Data de nascimento não pode ficar em branco'
    )
  end

  context 'and try to access' do
    scenario 'message route without a complete profile' do
      profile = create(:profile, name: 'Fulano',
                                 birth_date: '15/07/1989')
      login_as(profile.candidate, scope: :candidate)

      visit comments_list_profile_path(profile)

      expect(page).to have_content(
        'É necessario completar o perfil para se inscrever em qualquer vaga'
      )
      expect(current_path).to eq(edit_profile_path(profile))
    end

    scenario 'registered route without a complete profile' do
      profile = create(:profile, name: 'Fulano',
                                 birth_date: '15/07/1989')
      login_as(profile.candidate, scope: :candidate)

      visit registereds_path

      expect(page).to have_content(
        'É necessario completar o perfil para se inscrever em qualquer vaga'
      )
      expect(current_path).to eq(edit_profile_path(profile))
    end

    scenario 'job vacancy route without a complete profile' do
      profile = create(:profile, name: 'Fulano',
                                 birth_date: '15/07/1989')
      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path

      expect(page).to have_content(
        'É necessario completar o perfil para se inscrever em qualquer vaga'
      )
      expect(current_path).to eq(edit_profile_path(profile))
    end

    scenario 'proposal route without a complete profile' do
      profile = create(:profile, name: 'Fulano',
                                 birth_date: '15/07/1989')
      login_as(profile.candidate, scope: :candidate)

      visit proposals_path

      expect(page).to have_content(
        'É necessario completar o perfil para se inscrever em qualquer vaga'
      )
      expect(current_path).to eq(edit_profile_path(profile))
    end
  end

  context 'route access test' do
    scenario 'a no-authenticate usser try to access edit profile option' do
      visit new_profile_path

      expect(current_path).to eq(new_candidate_session_path)
    end
  end
end
