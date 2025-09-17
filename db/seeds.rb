require "factory_bot_rails"

include FactoryBot::Syntax::Methods
include ActionDispatch::TestProcess::FixtureFile

puts 'Seeding database...'

ActiveRecord::Base.transaction do

    puts 'Creating candidates...'
    candidates = create_list(:candidate, 20, :with_profile, password: 'qwe123QWE!@#')

    puts 'Creating headhunters and job vacancies...'
    headhunter_1 = create(:headhunter, email: 'headhunter_empresa1@email.com', password: 'qwe123QWE!@#')

    job_vacancy_1 = create(:job_vacancy, title: 'Desenvolvedor Ruby on Rails', 
                                        vacancy_description: 'Vaga para desenvolvedor Ruby on Rails', 
                                        ability_description: 'Conhecimento em Ruby on Rails', 
                                        level: :junior, 
                                        limit_date: 30.days.from_now, 
                                        region: 'Pinheiros, São Paulo - SP ', 
                                        minimum_wage: 3000, 
                                        maximum_wage: 5000, 
                                        headhunter: headhunter_1)

    job_vacancy_2 = create(:job_vacancy, title: 'Desenvolvedor React', 
                                        vacancy_description: 'Vaga para desenvolvedor React', 
                                        ability_description: 'Conhecimento em React', 
                                        level: :full, 
                                        limit_date: 30.days.from_now, 
                                        region: 'Remoto', 
                                        minimum_wage: 5000, 
                                        maximum_wage: 8000, 
                                        headhunter: headhunter_1)

    job_vacancy_3 = create(:job_vacancy, title: 'Desenvolvedor DevOps', 
                                        vacancy_description: 'Vaga para desenvolvedor DevOps', 
                                        ability_description: 'Conhecimento em DevOps', 
                                        level: :senior, 
                                        limit_date: 30.days.from_now, 
                                        region: 'Paulista, São Paulo - SP', 
                                        minimum_wage: 8000, 
                                        maximum_wage: 12000, 
                                        headhunter: headhunter_1)

    headhunter_2 = create(:headhunter, email: 'headhunter_empresa2@email.com', password: 'qwe123QWE!@#')

    job_vacancy_4 = create(:job_vacancy, title: 'Desenvolvedor Python', 
                                        vacancy_description: 'Vaga para desenvolvedor Python',
                                        ability_description: 'Conhecimento em Python',
                                        level: :junior,
                                        limit_date: 30.days.from_now,
                                        region: 'Bento Ribeiro, Rio de Janeiro - RJ',
                                        minimum_wage: 3000,
                                        maximum_wage: 5000,
                                        headhunter: headhunter_2)

    job_vacancy_5 = create(:job_vacancy, title: 'Desenvolvedor Java',
                                        vacancy_description: 'Vaga para desenvolvedor Java',
                                        ability_description: 'Conhecimento em Java',
                                        level: :full,
                                        limit_date: 30.days.from_now,
                                        region: 'Bento Ribeiro, Rio de Janeiro - RJ',
                                        minimum_wage: 5000,
                                        maximum_wage: 8000,
                                        headhunter: headhunter_2)

    headhunter_3 = create(:headhunter, email: 'headhunter_empresa3@email.com', password: 'qwe123QWE!@#')

    job_vacancy_6 = create(:job_vacancy, title: 'Desenvolvedor Mobile',
                                        vacancy_description: 'Vaga para desenvolvedor Mobile',
                                        ability_description: 'Conhecimento em Mobile',
                                        level: :senior,
                                        limit_date: 30.days.from_now,
                                        region: 'Remoto',
                                        minimum_wage: 8000,
                                        maximum_wage: 12000,
                                        headhunter: headhunter_3)

    puts 'Creating registrations...'

    candidates.each_with_index do |candidate, index|
        case index % 3
        when 0
            create(:registered, candidate: candidate, job_vacancy: job_vacancy_1)
            create(:registered, candidate: candidate, job_vacancy: job_vacancy_3)
        when 1
            create(:registered, candidate: candidate, job_vacancy: job_vacancy_4)
            create(:registered, candidate: candidate, job_vacancy: job_vacancy_5)
        when 2
            create(:registered, candidate: candidate, job_vacancy: job_vacancy_6)
        end
    end

    puts 'Creating comments...'
    candidates.each_with_index do |candidate, index|
        case index % 3
        when 0
            create(:comment, headhunter: headhunter_1, profile: candidate.profile)
        when 1
            create(:comment, headhunter: headhunter_2, profile: candidate.profile)
        when 2
            create(:comment, headhunter: headhunter_3, profile: candidate.profile)
        end
    end
end

puts 'Database seeded successfully!'