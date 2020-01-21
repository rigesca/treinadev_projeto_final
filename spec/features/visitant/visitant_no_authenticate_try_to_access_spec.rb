require 'rails_helper'

feature 'A visitor no-authenticate try to access' do
    
    scenario 'show proposal option' do
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
        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :proposal,
                                registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), 
                                    salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)
        visit proposal_path(proposal)

        expect(current_path).to eq(root_path)
    end
    
    scenario 'index proposal option' do
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
        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :proposal,
                                registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), 
                                    salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: registered.id)
        visit proposal_path(proposal)

        expect(current_path).to eq(root_path)
    end
end