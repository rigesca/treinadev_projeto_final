require 'rails_helper'

feature 'Headhunter register a commentary for a candidate' do
    scenario 'successfully' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')

        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')


        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate.id)

        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        commentary = Comment.create!(profile_id: profile.id, headhunter_id: headhunter.id, 
                                     comment:"Bom dia #{profile.name}, gostariamos de agendar uma entrevista com você, entre em contato no telefone 1812-5142")

        login_as(candidate, :scope => :candidate)

        visit root_path
        click_on 'Perfil'
        click_on 'Comentários' 

        expect(page).not_to have_button('Envia comentário')
        expect(page).to have_content(commentary.heading)
        expect(page).to have_content(commentary.comment)
        expect(page).to have_content(commentary.customized_send_time_message)
    end


    scenario 'and see multiplos comments successfully' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')

        headhunter_1 = Headhunter.create!(email: 'headhunter_1@teste.com',
                                          password: '123teste')

        headhunter_2 = Headhunter.create!(email: 'headhunter_2@teste.com',
                                          password: '123teste')
                                    
        headhunter_3 = Headhunter.create!(email: 'headhunter_3@teste.com',
                                          password: '123teste')
        
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate.id)

        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        comment_headhunter_1 = Comment.create!(profile_id: profile.id, headhunter_id: headhunter_1.id, 
                                     comment:"Bom dia #{profile.name}, gostariamos de agendar uma entrevista com você, entre em contato no telefone 1812-5142")

        comment_headhunter_2 = Comment.create!(profile_id: profile.id, headhunter_id: headhunter_2.id, 
                                        comment:"Bom dia #{profile.name}, gostariamos de agendar uma entrevista com você, entre em contato no telefone 1812-5142")

        comment_headhunter_3 = Comment.create!(profile_id: profile.id, headhunter_id: headhunter_3.id, 
                                        comment:"Bom dia #{profile.name}, gostariamos de agendar uma entrevista com você, entre em contato no telefone 1812-5142")

        login_as(candidate, :scope => :candidate)

        visit comments_list_profile_path(profile)

        expect(page).to have_content(comment_headhunter_2.heading)
        expect(page).to have_content(comment_headhunter_2.comment)
        expect(page).to have_content(comment_headhunter_2.customized_send_time_message)
        
        expect(page).to have_content(comment_headhunter_3.heading)
        expect(page).to have_content(comment_headhunter_3.comment)
        expect(page).to have_content(comment_headhunter_3.customized_send_time_message)
    end

    scenario 'and no have commentary in your profile' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate.id)

        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        login_as(candidate, :scope => :candidate)

        visit comments_list_profile_path(profile)

        expect(page).to have_content('O candidato não possui comentários registrado em seu perfil.')
    end
end