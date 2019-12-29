require 'rails_helper'

feature 'Headhunter make a proposal to a candidate'do
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

        page.find("##{registered.id}_create_proposal").click

        fill_in 'Salário', with: 2600
        fill_in 'Data de inicio das atividades', with: 15.day.from_now
        fill_in 'Data limite para a resposta a proposta', with: Date.today.next_day(7)
        fill_in 'Benefícios', with: 'Vale transporte, vale refeição, convenio medico e dentario.'
        fill_in 'Observações', with: 'O candidato devera usar roupas formais de segunda a quinta feita.'
        
        click_on 'Enviar'

        expect(page).to have_content("Proposta enviada ao candidato #{registered.candidate.profile.name} com sucesso")
        expect(page).not_to have_link("##{registered.id}_create_proposal")

        registered.reload

        expect(registered.status).to eq('proposal')
    end

    scenario 'and try to make a proposal witout a note' do
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
        visit proposal_registered_path(registered)

        fill_in 'Salário', with: 2600
        fill_in 'Data de inicio das atividades', with: 14.day.from_now
        fill_in 'Data limite para a resposta a proposta', with: Date.today.next_day(7)
        fill_in 'Benefícios', with: 'Vale transporte, vale refeição, convenio medico e dentario.'
        
        click_on 'Enviar'

        expect(page).to have_content("Proposta enviada ao candidato #{registered.candidate.profile.name} com sucesso")
        expect(page).not_to have_link("##{registered.id}_create_proposal")
    end
    
    scenario 'and try to make a proposal without filling in all fields' do
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
        visit proposal_registered_path(registered)

        click_on 'Enviar'

        expect(page).to have_content('Data inicial não pode ficar em branco')
        expect(page).to have_content('Salário não pode ficar em branco')        
        expect(page).to have_content('Benefícios não pode ficar em branco')
        expect(page).to have_content('Data limite para resposta não pode ficar em branco')
    end

    scenario 'and try to make a proposal with a invalid salary' do
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
        visit proposal_registered_path(registered)

        fill_in 'Salário', with: '2a100'
        fill_in 'Data de inicio das atividades', with: Date.today.prev_day(15)
        fill_in 'Data limite para a resposta a proposta', with: Date.today.next_day(7)
        fill_in 'Benefícios', with: 'Vale transporte, vale refeição, convenio medico e dentario.'
        
        click_on 'Enviar'

        expect(page).to have_content("Salário não é um número")
    end

    scenario 'and try to make a proposal with a lower starting date than today' do
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
        visit proposal_registered_path(registered)

        fill_in 'Salário', with: 2600
        fill_in 'Data de inicio das atividades', with: Date.today.prev_day(15)

        fill_in 'Benefícios', with: 'Vale transporte, vale refeição, convenio medico e dentario.'
        
        click_on 'Enviar'

        expect(page).to have_content("Data inicial deve ser maior que a data atual")
    end

    scenario 'and try to make a proposal with a lower salary than salary range' do
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
                                         maximum_wage: 3000,
                                         headhunter_id: headhunter.id)

        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, 
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        
        login_as(headhunter, :scope => :headhunter)
        visit proposal_registered_path(registered)

        fill_in 'Salário', with: 1500
        fill_in 'Data de inicio das atividades', with: Date.today.next_day(15)
        fill_in 'Data limite para a resposta a proposta', with: Date.today.next_day(7)
        fill_in 'Benefícios', with: 'Vale transporte, vale refeição, convenio medico e dentario.'
        
        click_on 'Enviar'

        expect(page).to have_content('Salário o valor deve estra dentro da faixa estipulado pela vaga.')
    end

    scenario 'and try to make a proposal with a bigger salary than salary range' do
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
                                         maximum_wage: 3000,
                                         headhunter_id: headhunter.id)

        registered = Registered.create!(candidate_id: candidate.id, job_vacancy_id: job_vacancy.id, 
                                        registered_justification: 'Estou preparado para exercer esse cargo na empresa')
        
        login_as(headhunter, :scope => :headhunter)
        visit proposal_registered_path(registered)

        fill_in 'Salário', with: 3200
        fill_in 'Data de inicio das atividades', with: Date.today.next_day(15)
        fill_in 'Benefícios', with: 'Vale transporte, vale refeição, convenio medico e dentario.'
        
        click_on 'Enviar'

        expect(page).to have_content('Salário o valor deve estra dentro da faixa estipulado pela vaga.')
    end

end