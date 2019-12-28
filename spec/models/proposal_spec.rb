require 'rails_helper'

RSpec.describe Proposal, type: :model do

  context '.start_date_must_be_greater_than_today' do
    it 'start date must exist' do
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
      
      proposal = registered.build_proposal(salary: 2600, limit_feedback_date: 7.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
      
      proposal.valid?
      
      expect(proposal.errors.full_messages).to include('Data inicial não pode ficar em branco')
    end

    it 'start date bigger than today' do
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
      
      proposal = registered.build_proposal(start_date: Date.today.next_day(15), limit_feedback_date: 7.day.from_now,
                                           salary: 2600,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
      
      proposal.valid?
      
      expect(proposal.errors.full_messages).to be_empty
    end
  
    it 'start date equal today' do
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
      
      proposal = registered.build_proposal(start_date: Date.today, salary: 2600, limit_feedback_date: 7.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
      
      proposal.valid?
      
      expect(proposal.errors.full_messages).to include('Data inicial deve ser maior que a data atual.')
    end

    it 'start date less than today' do
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
      
      proposal = registered.build_proposal(start_date: Date.today.prev_day(15), salary: 1500, limit_feedback_date: 7.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
      
      proposal.valid?
      
      expect(proposal.errors.full_messages).to include('Data inicial deve ser maior que a data atual.')
    end
  end   



  context '.salary_must_be_between_the_maximum_and_minimum_wage_values' do
    it 'salary must exist' do
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
    
      proposal = registered.build_proposal(start_date: Date.today.next_day(15), limit_feedback_date: 7.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
    
      proposal.valid?
    
      expect(proposal.errors.full_messages).to include('Salário não pode ficar em branco')
    end

    it 'salary must be between minimum and maximum wage' do
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
                                       maximum_wage: 3200,
                                       headhunter_id: headhunter.id)
    
      registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, 
                                      registered_justification: 'Estou preparado para exercer esse cargo na empresa')
    
      proposal = registered.build_proposal(start_date: Date.today.next_day(15), salary: 2850, limit_feedback_date: 7.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
    
      proposal.valid?
    
      expect(proposal.errors.full_messages).to be_empty
    end

    it 'salary must be equal to minimum wage' do
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
                                       maximum_wage: 3200,
                                       headhunter_id: headhunter.id)
    
      registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, 
                                      registered_justification: 'Estou preparado para exercer esse cargo na empresa')
    
      proposal = registered.build_proposal(start_date: Date.today.next_day(15), salary: 2500, limit_feedback_date: 7.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
    
      proposal.valid?
    
      expect(proposal.errors.full_messages).to be_empty
    end

    it 'salary must be equal to maximum wage' do
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
                                       maximum_wage: 3200,
                                       headhunter_id: headhunter.id)
    
      registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, 
                                      registered_justification: 'Estou preparado para exercer esse cargo na empresa')
    
      proposal = registered.build_proposal(start_date: Date.today.next_day(15), salary: 3200, limit_feedback_date: 7.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
    
      proposal.valid?
    
      expect(proposal.errors.full_messages).to be_empty
    end

    it 'salary must be less than minimum wage' do
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
                                       maximum_wage: 3200,
                                       headhunter_id: headhunter.id)

      registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, 
                                      registered_justification: 'Estou preparado para exercer esse cargo na empresa')

      proposal = registered.build_proposal(start_date: Date.today.next_day(15), salary: 1500, limit_feedback_date: 7.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
    
      proposal.valid?
    
      expect(proposal.errors.full_messages).to include('Salário o valor deve estra dentro da faixa estipulado pela vaga.')
    end

    it 'salary must be bigger than maximun wage' do
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
                                       maximum_wage: 3200,
                                       headhunter_id: headhunter.id)
    
      registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, 
                                      registered_justification: 'Estou preparado para exercer esse cargo na empresa')
    
      proposal = registered.build_proposal(start_date: Date.today.next_day(15), salary: 4000, limit_feedback_date: 7.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
    
      proposal.valid?
    
      expect(proposal.errors.full_messages).to include('Salário o valor deve estra dentro da faixa estipulado pela vaga.')
    end

  end



  context '.limit_date_must_be_between_today_and_start_date' do
    it 'limit date must exist' do
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
      
      proposal = registered.build_proposal(salary: 2600, start_date: 15.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
      
      proposal.valid?
      
      expect(proposal.errors.full_messages).to include('Data limite para resposta não pode ficar em branco')
    end

    it 'limit date must be between today and start date' do
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
      
      proposal = registered.build_proposal(salary: 2600, start_date: 15.day.from_now, limit_feedback_date: 7.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
      
      proposal.valid?
      
      expect(proposal.errors.full_messages).to be_empty
    end

    it 'limit date less than today date' do
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
      
      proposal = registered.build_proposal(salary: 2600, start_date: 15.day.from_now, limit_feedback_date: Date.current.prev_day(7),
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
      
      proposal.valid?
      
      expect(proposal.errors.full_messages).to include('Data limite para resposta deve ser maior que a data atual.')
    end

    it 'limit date equal today' do
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
      
      proposal = registered.build_proposal(salary: 2600, start_date: 15.day.from_now, limit_feedback_date: Date.current,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
      
      proposal.valid?
      
      expect(proposal.errors.full_messages).to include('Data limite para resposta deve ser maior que a data atual.')
    end

    it 'limit date bigger than start date' do
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
      
      proposal = registered.build_proposal(salary: 2600, start_date: 15.day.from_now, limit_feedback_date: 30.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
      
      proposal.valid?
      
      expect(proposal.errors.full_messages).to include('Data limite para resposta deve ser menor que a data de inicio das atividades.')
    end

    it 'limit date equal start date' do
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
      
      proposal = registered.build_proposal(salary: 2600, start_date: 15.day.from_now, limit_feedback_date: 15.day.from_now,
                                           benefits: 'Vale transporte, vale refeição, plano de saude.')                                
      
      proposal.valid?
      
      expect(proposal.errors.full_messages).to include('Data limite para resposta deve ser menor que a data de inicio das atividades.')
    end

  end
end
