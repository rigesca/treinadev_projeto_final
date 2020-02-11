# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate edits your profile' do
  scenario 'successfully' do
    profile = create(:profile, :with_photo,
                     name: 'Fulano Da Silva',
                     social_name: 'Siclano',
                     birth_date: '15/07/1989',
                     formation: 'Formado pela faculdade X',
                     description: 'Busco oportunidade como programador',
                     experience: 'Trabalhou por 2 anos na empresa X')
    login_as(profile.candidate, scope: :candidate)

    visit root_path
    click_on 'Perfil'
    click_on 'Editar'

    fill_in 'Nome completo', with: 'Siclano Da Silva'
    fill_in 'Nome social', with: 'Fulano'
    fill_in 'Data de nascimento', with: '12/03/1990'
    fill_in 'Formação', with: 'Formado na UNITEST'
    fill_in 'Descrição', with: 'Deseja trabalhar com Ruby'
    fill_in 'Experiência', with: '- Trabalho 1 anos e 6 messes na empresa Y'

    click_on 'Salvar'

    expect(current_path).to eq(profile_path(profile))
    expect(page).to have_content('Siclano Da Silva')
    expect(page).to have_content('Fulano')
    expect(page).to have_content(I18n.localize('12/03/1990'.to_date))
    expect(page).to have_content('Formado na UNITEST')
    expect(page).to have_content('Deseja trabalhar com Ruby')
    expect(page).to have_content('- Trabalho 1 anos e 6 messes na empresa Y')
  end

  scenario 'and change the name to an empty value' do
    profile = create(:profile, :with_photo,
                     name: 'Fulano Da Silva',
                     social_name: 'Siclano',
                     birth_date: '15/07/1989',
                     formation: 'Formado pela faculdade X',
                     description: 'Busco oportunidade como programador',
                     experience: 'Trabalhou por 2 anos na empresa X')
    login_as(profile.candidate, scope: :candidate)

    visit edit_profile_path(profile)

    fill_in 'Nome completo', with: ' '

    click_on 'Salvar'

    expect(page).to have_content('Nome completo não pode ficar em branco')
  end

  scenario 'and change the birth to an empty value' do
    profile = create(:profile, :with_photo,
                     name: 'Fulano Da Silva',
                     social_name: 'Siclano',
                     birth_date: '15/07/1989',
                     formation: 'Formado pela faculdade X',
                     description: 'Busco oportunidade como programador',
                     experience: 'Trabalhou por 2 anos na empresa X')
    login_as(profile.candidate, scope: :candidate)

    visit edit_profile_path(profile)

    fill_in 'Data de nascimento', with: ' '

    click_on 'Salvar'

    expect(page).to have_content('Data de nascimento não pode ficar em branco')
  end
end
