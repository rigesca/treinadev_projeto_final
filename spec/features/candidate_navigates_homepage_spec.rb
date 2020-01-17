require 'rails_helper'

feature 'Candidate navigates homepage' do
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

        expect(page).to have_content('Venha conhecer nossas vagas !')      

        expect(page).to have_link('Perfil')
        expect(page).to have_link('Mensagens')
        expect(page).to have_link('Minhas Vagas')
        expect(page).to have_link('Busca por vagas')
        expect(page).to have_link('Minhas propostas')
    end

    scenario 'and have proposals' do
        headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                        password: '123teste')

        candidate = Candidate.create!(email: 'candidate@teste.com',
                                      password: '123teste')
        profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                  birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                  description: 'Busco oportunidade como programador',
                                  experience: 'Trabalhou por 2 anos na empresa X',
                                  candidate_id: candidate.id)
        profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')), filename:'foto.jpeg')


        first_job_vacancy = JobVacancy.create!(title: 'Vaga de Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)

        first_registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: first_job_vacancy.id,
                                              registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        first_proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7),
                                          salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: first_registered.id)


        second_job_vacancy = JobVacancy.create!(title: 'Vaga de Ruby', 
                                                vacancy_description:'O profissional ira trabalhar com ruby',
                                                ability_description:'Conhecimento em TDD e ruby',
                                                level: :junior,
                                                limit_date: 7.day.from_now,
                                                region: 'Av.Paulista, 1000',
                                                minimum_wage: 2500,
                                                maximum_wage: 2800,
                                                headhunter_id: headhunter.id)

        second_registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: second_job_vacancy.id,
                                               registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        second_proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7),
                                           salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: second_registered.id)


        third_job_vacancy = JobVacancy.create!(title: 'Vaga de Ruby', 
                                               vacancy_description:'O profissional ira trabalhar com ruby',
                                               ability_description:'Conhecimento em TDD e ruby',
                                               level: :junior,
                                               limit_date: 7.day.from_now,
                                               region: 'Av.Paulista, 1000',
                                               minimum_wage: 2500,
                                               maximum_wage: 2800,
                                               headhunter_id: headhunter.id)

        third_registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: third_job_vacancy.id, status: :reject_proposal,
                                              registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        third_proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), status: :rejected,
                                          salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: third_registered.id)

        login_as(candidate, :scope => :candidate)

        visit root_path

        expect(page).to have_content('Você possui (2) propostas não analisadas ainda.')
    end
end