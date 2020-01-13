
require 'rails_helper'

feature 'Candidate sign in' do
    scenario 'successfully' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')

        visit root_path

        click_on 'Entrar como candidato'
        
        fill_in 'Email', with: candidate.email
        fill_in 'Senha', with: candidate.password

        click_on 'Log in'

        expect(page).to have_content('Login efetuado com sucesso!')
        expect(page).to have_content("Olá #{candidate.email}")
    end

    scenario 'try log in without filling in all fields' do
        visit root_path

        click_on 'Entrar como candidato'
        click_on 'Log in'

        expect(page).to have_content('Email ou senha inválida.')
    end

    scenario 'try log in with wrong password' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        
        visit root_path

        click_on 'Entrar como candidato'

        fill_in 'Email', with: 'headhunter@empresa.com'
        fill_in 'Senha', with: candidate.password

        click_on 'Log in'

        expect(page).to have_content('Email ou senha inválida.')
    end

    scenario 'try log in with wrong password' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        
        visit root_path

        click_on 'Entrar como candidato'

        fill_in 'Email', with: candidate.email
        fill_in 'Senha', with: 'teste123'

        click_on 'Log in'

        expect(page).to have_content('Email ou senha inválida.')
    end

    scenario 'and sign out' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        login_as(candidate)

        visit root_path

        click_on 'Sair'

        expect(page).to have_content('Saiu com sucesso')
    end
end