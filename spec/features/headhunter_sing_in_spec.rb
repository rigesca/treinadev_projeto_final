
require 'rails_helper'

feature 'Headhunter sing in' do
    scenario 'successfully' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                           password: '123teste')

        visit root_path

        click_on 'Entrar como headhunter'
        
        fill_in 'Email', with: headhunter.email
        fill_in 'Senha', with: headhunter.password

        click_on 'Log in'

        expect(page).to have_content('Login efetuado com sucesso!')
        expect(page).to have_content("Olá #{headhunter.email}")
    end

    scenario 'try log in without filling in all fields' do
        visit root_path

        click_on 'Entrar como headhunter'
        click_on 'Log in'

        expect(page).to have_content('Email ou senha inválida.')
    end

    scenario 'try log in with wrong password' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')
        
        visit root_path

        click_on 'Entrar como headhunter'

        fill_in 'Email', with: 'headhunter@empresa.com'
        fill_in 'Senha', with: headhunter.password

        click_on 'Log in'

        expect(page).to have_content('Email ou senha inválida.')
    end

    scenario 'try log in with wrong password' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')
        
        visit root_path

        click_on 'Entrar como headhunter'

        fill_in 'Email', with: headhunter.email
        fill_in 'Senha', with: 'teste123'

        click_on 'Log in'

        expect(page).to have_content('Email ou senha inválida.')
    end

    scenario 'and sign out' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')
        login_as(headhunter, :scope => :headhunter)

        visit root_path

        click_on 'Sair'

        expect(page).to have_content('Saiu com sucesso')
    end
end