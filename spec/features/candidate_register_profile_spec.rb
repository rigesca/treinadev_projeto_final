require 'rails_helper'

feature 'Candidate register a profile' do
    scenario 'successufully' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        login_as(candidate, :scope => :candidate)

        visit root_path

        fill_in 'Nome completo', with: 'Fulano Siclano'
        fill_in 'Nome social', with: 'Siclano'
        fill_in 'Data de nascimento', with: '15/07/1989'
        attach_file 'Foto do candidato', Rails.root.join('spec', 'support', 'foto.jpeg')
        fill_in 'Formação', with: 'Graduado em analise de sistema'
        fill_in 'Descrição', with: 'Busco oportunidade como programador'
        fill_in 'Experiência', with: 'Trabalho 2 anos na empresa X'

        click_on 'Salvar'

        expect(page).to have_content('Perfil concluido com sucesso')
        expect(current_path).to eq(root_path)
    end

    scenario 'but incomplete profile' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        login_as(candidate, :scope => :candidate)

        visit root_path

        fill_in 'Nome completo', with: 'Fulano Siclano'
        
        click_on 'Salvar'

        profile = Profile.last

        expect(page).to have_content('É necessario completar o perfil para se inscrever em qualquer vaga')
        expect(current_path).to eq(edit_profile_path(profile))
    end

    scenario 'and do not fill in the name' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        login_as(candidate, :scope => :candidate)

        visit root_path
        
        click_on 'Salvar'

        expect(page).to have_content('Nome completo não pode ficar em branco')
    end
end