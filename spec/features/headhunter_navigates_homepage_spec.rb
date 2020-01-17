require 'rails_helper'

feature 'Headhunter navigates homepage' do
    scenario 'successfully' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')

        login_as(headhunter, :scope => :headhunter)

        visit root_path

        expect(page).to have_content('Venha conhecer nossas vagas !')      

        expect(page).to have_link('Vagas')
        expect(page).to have_link('Propostas')
    end
end