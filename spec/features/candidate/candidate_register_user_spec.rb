require 'rails_helper'

feature 'Candidate register a user' do
    scenario 'successfully' do
        visit root_path

        click_on 'Cadastrar-se como candidato'
        
        fill_in 'Email', with: 'candidate@teste.com'
        fill_in 'Senha', with: 'candidate123'
        fill_in 'Confirmação de senha', with: 'candidate123'

        click_on 'Sign up'

        expect(page).to have_content('É necessario cadastrar um perfil para utilizar o sistema')
    end

    scenario 'try register without filling in all fields' do
        visit root_path

        click_on 'Cadastrar-se como candidato'
        click_on 'Sign up'

        expect(page).to have_content('Email não pode ficar em branco')
        expect(page).to have_content('Senha não pode ficar em branco')
    end

    scenario 'try register with different password and confirmation password' do
        visit root_path

        click_on 'Cadastrar-se como candidato'

        fill_in 'Email', with: 'candidate@teste.com'
        fill_in 'Senha', with: '123teste'
        fill_in 'Confirmação de senha', with: 'teste123'

        click_on 'Sign up'

        expect(page).to have_content('Confirmação de senha não é igual a Senha')
    end
end