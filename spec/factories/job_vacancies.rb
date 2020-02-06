# frozen_string_literal: true

FactoryBot.define do
  factory :job_vacancy do
    title { 'Desenvolvedor Ruby' }
    vacancy_description { 'Ira atuar projetando novas funcionalidades e aplicando TDD no projeto' }
    ability_description { 'Conhecimentos em Ruby,Rails, desenvolvimento Agil, web e TDD.' }
    level { %i[trainee junior full senior specialist manager].sample }
    minimum_wage { 1500 }
    maximum_wage { 3000 }
    limit_date { 30.day.from_now }
    region { 'Av. Paulista, 1000' }
    headhunter
  end
end
