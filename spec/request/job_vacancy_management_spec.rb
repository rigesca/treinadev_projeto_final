require 'rails_helper'

describe 'JobVacancy', type: :request do
    
    context 'try to create' do
        it 'successfully' do
            headhunter = create(:headhunter)
            
            post api_v1_job_vacancies_path, params: { title: 'Vaga desenvolvedor JAVA',
                                                      vacancy_description: 'O candidato ira trabalhar com java',
                                                      ability_description: 'Conhecimentos em JAVA e SCRUN',
                                                      level: :junior, minimum_wage: 1500, maximum_wage: 3000,
                                                      limit_date: 30.day.from_now, region: 'Av. Antonio de Chaves, 120',
                                                      headhunter_id: headhunter.id }
            
            
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:created)

            job_vacancy = JobVacancy.find(json[:id])

            expect(job_vacancy.title).to eq('Vaga desenvolvedor JAVA')
            expect(job_vacancy.vacancy_description).to eq('O candidato ira trabalhar com java')
            expect(job_vacancy.ability_description).to eq('Conhecimentos em JAVA e SCRUN')
            expect(job_vacancy.level).to eq('junior')
            expect(job_vacancy.minimum_wage).to eq(1500)
            expect(job_vacancy.maximum_wage).to eq(3000)
            expect(job_vacancy.limit_date).to eq(30.day.from_now.to_date)
            expect(job_vacancy.region).to eq('Av. Antonio de Chaves, 120')
            expect(job_vacancy.headhunter_id).to eq(headhunter.id)
        end

        it 'withou values' do
            expect{ 
                    post api_v1_job_vacancies_path, params: { }
                    }.to change(JobVacancy, :count).by(0)

            expect(response).to have_http_status(412)
        end

        it 'got some server erro' do
            headhunter = create(:headhunter)

            allow_any_instance_of(JobVacancy).to receive(:save!).and_return(false)
            
            post api_v1_job_vacancies_path, params: { title: 'Vaga desenvolvedor JAVA',
                                                      vacancy_description: 'O candidato ira trabalhar com java',
                                                      ability_description: 'Conhecimentos em JAVA e SCRUN',
                                                      level: :junior, minimum_wage: 1500, maximum_wage: 3000,
                                                      limit_date: 30.day.from_now, region: 'Av. Antonio de Chaves, 120',
                                                      headhunter_id: headhunter.id }
            
            expect(response).to have_http_status(500)
        end
    end

    context 'try to show' do
        it 'successfully' do
            job_vacancy = create(:job_vacancy)

            get api_v1_job_vacancy_path(job_vacancy)

            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok)

            expect(json[:title]).to eq(job_vacancy.title)
            expect(json[:vacancy_description]).to eq(job_vacancy.vacancy_description)
            expect(json[:ability_description]).to eq(job_vacancy.ability_description)
            expect(json[:level]).to eq(job_vacancy.level)
            expect(json[:limit_date].to_date).to eq(job_vacancy.limit_date)
            expect(json[:region]).to eq(job_vacancy.region)
            expect(json[:maximum_wage]).to eq(job_vacancy.maximum_wage)
            expect(json[:minimum_wage]).to eq(job_vacancy.minimum_wage)
            expect(json[:headhunter_id]).to eq(job_vacancy.headhunter_id)
        end

        it 'using a non-existent value' do
            get api_v1_job_vacancy_path(id: 999)
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(412)
            expect(json[:message]).to eq('Object not found')
        end
    end

    context 'try to index' do
        it 'successfully' do
            job_vacancy_list = create_list(:job_vacancy, 5)
                        
            get api_v1_job_vacancies_path

            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok)

            expect(json[0][:title]).to eq(job_vacancy_list[0][:title])
            expect(json[1][:title]).to eq(job_vacancy_list[1][:title])
            expect(json[2][:title]).to eq(job_vacancy_list[2][:title])
            expect(json[3][:title]).to eq(job_vacancy_list[3][:title])
            expect(json[4][:title]).to eq(job_vacancy_list[4][:title])
        end

        it 'and not have any registered' do
            get api_v1_job_vacancies_path

            expect(response).to have_http_status(:no_content)
        end
    end
end