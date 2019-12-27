require 'rails_helper'

feature 'Headhunter register a job vacancy' do
    scenario 'successfully' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')
        login_as(headhunter, :scope => :headhunter)

        visit root_path
        click_on 'Vagas'
        click_on 'Cadastrar vaga'

        fill_in 'Título', with: 'Vaga de programador ruby'
        fill_in 'Descrição', with: 'A empresa busca por programadores ruby'
        fill_in 'Habilidades necessarias', with: 'Conhecer TDD e ruby'
        fill_in 'Valor minimo', with: 2500
        fill_in 'Valor maximo', with: 3000
        choose('Júnior')
        fill_in 'Data limite para inscrições', with: 7.day.from_now
        fill_in 'Região da vaga', with: 'Av. Paulista, 100'

        click_on 'Salvar'

        expect(page).to have_content('Vaga criada com sucesso.')
        expect(page).to have_content('Vaga de programador ruby')
    end

    scenario 'try register without filling in all fields' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
            password: '123teste')
        login_as(headhunter, :scope => :headhunter)
        
        visit new_job_vacancy_path

        click_on 'Salvar'

        expect(page).to have_content('Título não pode ficar em branco')
        expect(page).to have_content('Descrição da vaga não pode ficar em branco')
        expect(page).to have_content('Habilidades necessarias não pode ficar em branco')
        expect(page).to have_content('Data limite para inscrições não pode ficar em branco')
        expect(page).to have_content('Região da vaga não pode ficar em branco')
        expect(page).to have_content('Valor minimo não é um número')
        expect(page).to have_content('Valor maximo não é um número')
    end

    scenario 'try register with a limit date less than today' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
            password: '123teste')
        login_as(headhunter, :scope => :headhunter)
        
        visit new_job_vacancy_path

        fill_in 'Título', with: 'Vaga de programador ruby'
        fill_in 'Descrição', with: 'A empresa busca por programadores ruby'
        fill_in 'Habilidades necessarias', with: 'Conhecer TDD e ruby'
        fill_in 'Valor minimo', with: 2500
        fill_in 'Valor maximo', with: 3000
        choose('Especialista')
        fill_in 'Data limite para inscrições', with: Date.today.prev_day(3)
        fill_in 'Região da vaga', with: 'Av. Paulista, 100'

        click_on 'Salvar'

        expect(page).to have_content('Data limite para inscrições deve ser maior que a data atual.')
    end

    scenario 'try register with a minimum wage bigger than maximum' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
            password: '123teste')
        login_as(headhunter, :scope => :headhunter)
        
        visit new_job_vacancy_path

        fill_in 'Título', with: 'Vaga de programador ruby'
        fill_in 'Descrição', with: 'A empresa busca por programadores ruby'
        fill_in 'Habilidades necessarias', with: 'Conhecer TDD e ruby'
        fill_in 'Valor minimo', with: 3000
        fill_in 'Valor maximo', with: 1500
        choose('Estágiario')
        fill_in 'Data limite para inscrições', with: 15.day.from_now
        fill_in 'Região da vaga', with: 'Av. Paulista, 100'

        click_on 'Salvar'

        expect(page).to have_content('Valor minimo deve ser menor que o valor maximo.')
    end

    scenario 'try register with a minimum wage below zero' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
            password: '123teste')
        login_as(headhunter, :scope => :headhunter)
        
        visit new_job_vacancy_path

        fill_in 'Título', with: 'Vaga de programador ruby'
        fill_in 'Descrição', with: 'A empresa busca por programadores ruby'
        fill_in 'Habilidades necessarias', with: 'Conhecer TDD e ruby'
        fill_in 'Valor minimo', with: -50
        fill_in 'Valor maximo', with: 1500
        choose('Pleno')
        fill_in 'Data limite para inscrições', with: 15.day.from_now
        fill_in 'Região da vaga', with: 'Av. Paulista, 100'

        click_on 'Salvar'

        expect(page).to have_content('Valor minimo deve ser maior ou igual a 0')
    end
end