require 'rails_helper'

RSpec.describe JobVacancy, type: :model do

  context '.maximun_wage_not_be_greater_than_minimum' do
    it 'minimum wage less than maximo wage' do
      headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                      password: '123teste')
            
      job_vacancy = JobVacancy.new(title: 'Vaga de Ruby', 
                                   vacancy_description:'O profissional ira trabalhar com ruby',
                                   ability_description:'Conhecimento em TDD e ruby',
                                   level: :junior,
                                   limit_date: 7.day.from_now,
                                   region: 'Av.Paulista, 1000',
                                   minimum_wage: 2500,
                                   maximum_wage: 2800,
                                   headhunter_id: headhunter.id)
      
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to be_empty
    end

    it 'minimum and maximun wage must be equal' do
      headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                      password: '123teste')
            
      job_vacancy = JobVacancy.new(title: 'Vaga de Ruby', 
                                   vacancy_description:'O profissional ira trabalhar com ruby',
                                   ability_description:'Conhecimento em TDD e ruby',
                                   level: :junior,
                                   limit_date: 7.day.from_now,
                                   region: 'Av.Paulista, 1000',
                                   minimum_wage: 2500,
                                   maximum_wage: 2500,
                                   headhunter_id: headhunter.id)
      
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to be_empty
    end

    it 'minimum wage bigger than maximo wage' do
      headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                      password: '123teste')
            
      job_vacancy = JobVacancy.new(title: 'Vaga de Ruby', 
                                   vacancy_description:'O profissional ira trabalhar com ruby',
                                   ability_description:'Conhecimento em TDD e ruby',
                                   level: :junior,
                                   limit_date: 7.day.from_now,
                                   region: 'Av.Paulista, 1000',
                                   minimum_wage: 3100,
                                   maximum_wage: 2500,
                                   headhunter_id: headhunter.id)
      
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include('Valor minimo deve ser menor que o valor maximo.')
    end

    it 'minimum wage must exist' do
      headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                      password: '123teste')
            
      job_vacancy = JobVacancy.new(title: 'Vaga de Ruby', 
                                   vacancy_description:'O profissional ira trabalhar com ruby',
                                   ability_description:'Conhecimento em TDD e ruby',
                                   level: :junior,
                                   limit_date: 7.day.from_now,
                                   region: 'Av.Paulista, 1000',
                                   maximum_wage: 2500,
                                   headhunter_id: headhunter.id)
      
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include('Valor minimo não é um número')
    end

    it 'maximum wage must exist' do
      headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                      password: '123teste')
            
      job_vacancy = JobVacancy.new(title: 'Vaga de Ruby', 
                                   vacancy_description:'O profissional ira trabalhar com ruby',
                                   ability_description:'Conhecimento em TDD e ruby',
                                   level: :junior,
                                   limit_date: 7.day.from_now,
                                   region: 'Av.Paulista, 1000',
                                   minimum_wage: 2500,
                                   headhunter_id: headhunter.id)
      
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include('Valor maximo não é um número')
    end

    it 'minimum wage below zero' do
      headhunter = Headhunter.create!(email: 'headhunter@teste.com',
                                      password: '123teste')
            
      job_vacancy = JobVacancy.new(title: 'Vaga de Ruby', 
                                   vacancy_description:'O profissional ira trabalhar com ruby',
                                   ability_description:'Conhecimento em TDD e ruby',
                                   level: :junior,
                                   limit_date: 7.day.from_now,
                                   region: 'Av.Paulista, 1000',
                                   minimum_wage: -100,
                                   maximum_wage: 2500,
                                   headhunter_id: headhunter.id)
      
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include('Valor minimo deve ser maior ou igual a 0')
    end
  end


  context '.limit_date_must_be_greater_than_today' do
    
    it 'limit date bigger than today' do
      headhunter = Headhunter.create!(email: 'headhunter@teste.com',
        password: '123teste')

      job_vacancy = JobVacancy.new(title: 'Vaga de Ruby', 
          vacancy_description:'O profissional ira trabalhar com ruby',
          ability_description:'Conhecimento em TDD e ruby',
          level: :junior,
          limit_date: 7.day.from_now,
          region: 'Av.Paulista, 1000',
          minimum_wage: 2500,
          maximum_wage: 2800,
          headhunter_id: headhunter.id)

      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to be_empty
    end

    it 'limit date equal today' do
      headhunter = Headhunter.create!(email: 'headhunter@teste.com',
        password: '123teste')

      job_vacancy = JobVacancy.new(title: 'Vaga de Ruby', 
          vacancy_description:'O profissional ira trabalhar com ruby',
          ability_description:'Conhecimento em TDD e ruby',
          level: :junior,
          limit_date: Date.current,
          region: 'Av.Paulista, 1000',
          minimum_wage: 2500,
          maximum_wage: 2800,
          headhunter_id: headhunter.id)

      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include('Data limite para inscrições deve ser maior que a data atual.')
    end

    it 'limit date less than today' do
      headhunter = Headhunter.create!(email: 'headhunter@teste.com',
        password: '123teste')

      job_vacancy = JobVacancy.new(title: 'Vaga de Ruby', 
          vacancy_description:'O profissional ira trabalhar com ruby',
          ability_description:'Conhecimento em TDD e ruby',
          level: :junior,
          limit_date: Date.today.prev_day(7),
          region: 'Av.Paulista, 1000',
          minimum_wage: 2500,
          maximum_wage: 2800,
          headhunter_id: headhunter.id)

      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include('Data limite para inscrições deve ser maior que a data atual.')
    end

    it 'limit date must exist' do
      headhunter = Headhunter.create!(email: 'headhunter@teste.com',
        password: '123teste')

      job_vacancy = JobVacancy.new(title: 'Vaga de Ruby', 
          vacancy_description:'O profissional ira trabalhar com ruby',
          ability_description:'Conhecimento em TDD e ruby',
          level: :junior,
          region: 'Av.Paulista, 1000',
          minimum_wage: 2500,
          maximum_wage: 2800,
          headhunter_id: headhunter.id)

      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include('Data limite para inscrições não pode ficar em branco')
    end

  end

end
