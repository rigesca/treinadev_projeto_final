require 'rails_helper'

feature 'Headhunter closes job vacancy' do
    scenario 'successfully' do
        headhunter = create(:headhunter)
        
        first_candidate = Candidate.create!(email: 'candidate1@teste.com',
                                            password: '123teste')
        
        first_profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                        birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                        description: 'Busco oportunidade como programador',
                                        experience: 'Trabalhou por 2 anos na empresa X',
                                        candidate_id: first_candidate.id)
        first_profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                             filename:'foto.jpeg')

        second_candidate = Candidate.create!(email: 'candidate2@teste.com',
                                             password: '123teste')
        
        second_profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                         birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                         description: 'Busco oportunidade como programador',
                                         experience: 'Trabalhou por 2 anos na empresa X',
                                         candidate_id: second_candidate.id)
        second_profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
                                              filename:'foto.jpeg')

        third_candidate = Candidate.create!(email: 'candidate3@teste.com',
                                             password: '123teste')
        
        third_profile = Profile.create!(name: 'Fulano Da Silva', social_name: 'Siclano', 
                                         birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                                         description: 'Busco oportunidade como programador',
                                         experience: 'Trabalhou por 2 anos na empresa X',
                                         candidate_id: third_candidate.id)
        third_profile.candidate_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
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
        
        accept_registered = Registered.create!(candidate_id: first_candidate.id, job_vacancy_id: job_vacancy.id, status: :accept_proposal,
                                               registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        in_progress_registered = Registered.create!(candidate_id: second_candidate.id, job_vacancy_id: job_vacancy.id, 
                                               registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        reject_registered = Registered.create!(candidate_id: third_candidate.id, job_vacancy_id: job_vacancy.id, status: :reject_proposal,
                                               registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        rejected_proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), status: :rejected,
                                               salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: reject_registered.id)

        accepted_proposal = Proposal.create!(start_date: Date.current.next_day(15), limit_feedback_date: Date.current.next_day(7), status: :accepted,
                                    salary: 2600, benefits: 'VT, VR, convenio medico e seguro de vida', registered_id: accept_registered.id)
        
        login_as(headhunter, :scope => :headhunter)
        visit root_path
        click_on 'Vagas'
        click_on job_vacancy.heading

        click_on 'Encerra vaga'

        expect(page).to have_content("#{I18n.t(:closed, scope: [:enum, :statuses])}")
        expect(page).to have_no_link('Lista Candidatos')
        
        job_vacancy.reload
        expect(job_vacancy.status).to eq('closed')

        reject_registered.reload
        expect(reject_registered.status).to eq('closed')
        expect(reject_registered.proposal).to eq(nil)

        in_progress_registered.reload
        expect(in_progress_registered.status).to eq('closed')
    end


    scenario 'and others candidate register be closed' do
        headhunter = create(:headhunter)
        
        candidate = Candidate.create!(email: 'candidate1@teste.com',
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
        
        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, status: :closed,
                                               registered_justification: 'Estou preparado para exercer esse cargo na empresa')

        
        login_as(candidate, :scope => :candidate)
        visit root_path
        click_on 'Minhas Vagas'

        expect(page).to have_content("#{I18n.t(:closed, scope: [:enum, :statuses])}")
        expect(page).to have_no_link(job_vacancy.heading)
        expect(page).to have_content('Vaga encerrada!')
    end
end