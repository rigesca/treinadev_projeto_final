require 'rails_helper'

RSpec.describe 'ProposalMailer' do
    describe '#received_proposal' do
        it 'should send a email to a candidate' do
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

            email = ProposalMailer.received_proposal(proposal.id)

            expect(email.to).to include(candidate.email)
        end

        it 'should sendo a email from a headhunter' do
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

            email = ProposalMailer.received_proposal(proposal.id)

            expect(email.from).to include('no-reply@tpf.com.br')
        end

        it 'should send a email with a subtitle' do
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

            email = ProposalMailer.received_proposal(proposal.id)

            expect(email.subject).to eq('Proposta enviada para seu perfil!')
        end

        it 'shoudl send a email with a body' do
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

            email = ProposalMailer.received_proposal(proposal.id)

            expect(email.body).to include("Olá #{profile.name}, você acaba de receber uma proposta para a vaga: #{job_vacancy.title}.")
            expect(email.body).to include("O inicio das atividades esta prevista para a #{I18n.localize proposal.start_date}.")
            expect(email.body).to include("Acesse seu usuário para mais informações sobre a proposta.")
            expect(email.body).to include("ATENÇÃO: Você tem ate dia #{I18n.localize proposal.limit_feedback_date} para responder a proposta, caso contrario ela sera encerrada.")
        end
    end
end