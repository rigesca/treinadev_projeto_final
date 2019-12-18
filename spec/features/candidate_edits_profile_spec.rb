require 'rails_helper'

feature 'Candidate edits your profile' do
    scenario 'successfully' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                              birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                              description: 'Busco oportunidade como programador',
                              experience: 'Trabalhou por 2 anos na empresa X',
                              candidate_id: candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')    

        login_as(candidate, :scope => :candidate)

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

end