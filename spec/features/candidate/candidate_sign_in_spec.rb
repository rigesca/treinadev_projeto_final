# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate sign in' do
  scenario 'successfully' do
    candidate = create(:candidate, email: 'candidate@teste.com',
                                   password: '123teste')
    create(:profile, :with_photo, candidate: candidate)

    visit root_path

    click_on 'Entrar como candidato'

    fill_in 'Email', with: candidate.email
    fill_in 'Senha', with: candidate.password

    click_on 'Log in'

    expect(page).to have_content('Login efetuado com sucesso!')
    expect(page).to have_content('Olá candidate@teste.com')
  end

  scenario 'try log in without filling in all fields' do
    visit root_path

    click_on 'Entrar como candidato'
    click_on 'Log in'

    expect(page).to have_content('Email ou senha inválida.')
  end

  scenario 'try log in with wrong password' do
    candidate = create(:candidate, email: 'candidate@teste.com',
                                   password: '123teste')

    visit root_path

    click_on 'Entrar como candidato'

    fill_in 'Email', with: 'headhunter@empresa.com'
    fill_in 'Senha', with: candidate.password

    click_on 'Log in'

    expect(page).to have_content('Email ou senha inválida.')
  end

  scenario 'try log in with wrong password' do
    candidate = create(:candidate, email: 'candidate@teste.com',
                                   password: '123teste')

    visit root_path

    click_on 'Entrar como candidato'

    fill_in 'Email', with: candidate.email
    fill_in 'Senha', with: 'teste123'

    click_on 'Log in'

    expect(page).to have_content('Email ou senha inválida.')
  end

  scenario 'and sign out' do
    candidate = create(:candidate, email: 'candidate@teste.com',
                                   password: '123teste')
    create(:profile, :with_photo, candidate: candidate)

    login_as(candidate)

    visit root_path

    click_on 'Sair'

    expect(page).to have_content('Saiu com sucesso')
  end
end
