require 'rails_helper'

feature 'Candidate consults apply vacancy'do
    scenario 'successfully' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')

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

        login_as(candidate, :scope => :candidate)

        visit root_path
        click_on 'Minhas Vagas'

        click_on job_vacancy.heading

        expect(page).to have_content(job_vacancy.title)
        expect(page).to have_content(I18n.t(job_vacancy.status, scope: [:enum,:statuses]))
        
        expect(page).to have_content('Você já se encontra inscrito para essa vaga.')
    end

    scenario 'without vacancy aplly' do
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

        visit root_path
        click_on 'Minhas Vagas'

        expect(page).to have_content('Você não possui nenhum inscrição em nenhuma vaga do site')
    end

    scenario 'and be rejected' do
        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                       filename:'foto.jpeg')

        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')

        job_vacancy = JobVacancy.create!(title: 'Vaga de Ruby', 
                                         vacancy_description:'O profissional ira trabalhar com ruby',
                                         ability_description:'Conhecimento em TDD e ruby',
                                         level: :junior,
                                         limit_date: 7.day.from_now,
                                         region: 'Av.Paulista, 1000',
                                         minimum_wage: 2500,
                                         maximum_wage: 2800,
                                         headhunter_id: headhunter.id)

        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :excluded,
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa',
                                        closed_feedback: 'O candidato não apresenta todos os requisitos necessarios')

        login_as(candidate, :scope => :candidate)

        visit root_path
        click_on 'Minhas Vagas'

        expect(page).to have_content('O candidato não apresenta todos os requisitos necessarios')
        expect(page).to have_content(I18n.t(registered.status, scope: [:enum,:statuses]))
    end


    context 'route access test' do
        scenario 'a no-authenticate usser try to access index registered option' do
            visit registereds_path 

            expect(current_path).to eq(root_path)
        end
    end
end