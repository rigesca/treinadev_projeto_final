require 'rails_helper'

feature 'Headhunter register a commentary for a candidate' do
    scenario 'successfully' do
        headhunter = create(:headhunter)
        
        job_vacancy= create(:job_vacancy, headhunter: headhunter)
        registered = create(:registered, job_vacancy: job_vacancy)
        
        profile = registered.candidate.profile
        
byebug

        login_as(headhunter, :scope => :headhunter)

        visit root_path
        
        click_on 'Vagas'
        click_on job_vacancy.heading
        click_on 'Lista Candidatos'
        click_on "#{profile.name} - #{profile.calculates_candidate_age}"
        click_on 'Comentários' 
        
        fill_in 'Comentário', with: "Boa tarde #{profile.name}, gostamos muito do seu perfil, você utiliza linkeding ?" 

        click_on 'Envia comentário'

        commentary = Comment.last

        expect(page).to have_content(commentary.heading)
        expect(page).to have_content("Boa tarde #{profile.name}, gostamos muito do seu perfil, você utiliza linkeding ?")
        expect(page).to have_content(commentary.customized_send_time_message)
    end

    scenario 'and try to send a comentary without a text' do
        headhunter = create(:headhunter)
        
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')

        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate.id)

        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        login_as(headhunter, :scope => :headhunter)

        visit comments_list_profile_path(profile) 
        
        click_on 'Envia comentário'

        expect(page).to have_content("Comentário não pode ficar em branco")
        expect(page).to have_content("O candidato não possui comentários registrado em seu perfil.")
    end

    scenario 'and headhunter cant see a commentary from another headhunter' do
        headhunter_1 = create(:headhunter)

        headhunter_2 = create(:headhunter)
        
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')

        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate.id)

        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        headhunter_1_comentary = Comment.create!(headhunter_id:headhunter_1.id, profile_id:profile.id, 
                                                 comment: "Boa noite, sou o Headhunter 1 e gostaria de falar com vc")
        headhunter_2_comentary = Comment.create!(headhunter_id:headhunter_2.id, profile_id:profile.id, 
                                                 comment: "Boa noite, sou o Headhunter 2 e gostaria de falar com vc")

        login_as(headhunter_1, :scope => :headhunter)

        visit comments_list_profile_path(profile) 
        
        expect(page).to have_content("Boa noite, sou o Headhunter 1 e gostaria de falar com vc")
        expect(page).not_to have_content("Boa noite, sou o Headhunter 2 e gostaria de falar com vc")
    end



    context 'route access test' do
        scenario 'a no-authenticate usser try to access commentary list option' do
            candidate = Candidate.create!(email: 'candidate@teste.com',
                                          password: '123teste')

            profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                      birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                      description: 'Busco oportunidade como programador',
                                      experience: 'Trabalhou por 2 anos na empresa X',
                                      candidate_id: candidate.id)

            profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                           filename:'foto.jpeg')
            
            visit comments_list_profile_path(profile)

            expect(current_path).to eq(root_path)
        end
    end
end