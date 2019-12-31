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

        job_vacancy = JobVacancy.create!(title: 'Vaga de Ruby', 
                                         vacancy_description:'O profissional ira trabalhar com ruby',
                                         ability_description:'Conhecimento em TDD e ruby',
                                         level: :junior,
                                         limit_date: 7.day.from_now,
                                         region: 'Av.Paulista, 1000',
                                         minimum_wage: 2500,
                                         maximum_wage: 2800,
                                         headhunter_id: headhunter.id)


        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id,
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        login_as(headhunter, :scope => :headhunter)

        visit root_path
        click_on 'Vagas'
        click_on job_vacancy.heading
        click_on 'Lista Candidatos'
        click_on "#{candidate.profile.name} - #{candidate.profile.calculates_candidate_age}"
        click_on 'Comentários' 
        
        fill_in 'Comentário', with: "Boa tarde #{candidate.profile.name}, gostamos muito do seu perfil, você utiliza linkeding ?" 

        click_on 'Envia comentário'

        commentary = Comment.last

        expect(page).to have_content(commentary.heading)
        expect(page).to have_content(commentary.comment)
        expect(page).to have_content(commentary.customized_send_time_message)
    end

    scenario 'and try to send a comentary without a text' do
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

        login_as(headhunter, :scope => :headhunter)

        visit comments_list_profile_path(profile) 
        
        click_on 'Envia comentário'

        expect(page).to have_content("Comentário não pode ficar em branco")
        expect(page).to have_content("O candidato não possui comentários registrado em seu perfil.")
    end

    scenario 'and headhunter cant see a commentary from another headhunter' do
        headhunter_1 = Headhunter.create!(email: 'headhunter@teste_1.com',
                                          password: '123teste')

        headhunter_2 = Headhunter.create!(email: 'headhunter@teste_2.com',
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