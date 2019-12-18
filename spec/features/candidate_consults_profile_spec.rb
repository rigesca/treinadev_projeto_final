require 'rails_helper'

feature 'Candidate consults your profile' do
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

        expect(page).to have_content(profile.name)
        expect(page).to have_content(profile.social_name)
        expect(page).to have_content(I18n.localize profile.birth_date)
        expect(page).to have_content(profile.formation)
        expect(page).to have_content(profile.description)
        expect(page).to have_content(profile.experience)
    end

    scenario 'successfully and go back to root' do
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

        expect(page).to have_content(profile.name)
        expect(page).to have_content(profile.social_name)
        expect(page).to have_content(I18n.localize profile.birth_date)
        expect(page).to have_content(profile.formation)
        expect(page).to have_content(profile.description)
        expect(page).to have_content(profile.experience)

        click_on 'Voltar'

        expect(current_path).to eq(root_path)
    end
end