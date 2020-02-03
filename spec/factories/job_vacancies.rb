# frozen_string_literal: true

FactoryBot.define do
  factory :job_vacancy do
    title { 'Desenvolvedor Ruby' }
    vacancy_description { 'O funcionario ira atuar na área de desenvolvimento criando novas funcionalidades e desenvolvendo testes para os programas criados.' }
    ability_description { 'Conhecimentos em Ruby,Rails, desenvolvimento Agil, web e TDD.' }
    level { %i[trainee junior full senior specialist manager].sample }
    minimum_wage { 1500 }
    maximum_wage { 3000 }
    limit_date { 30.day.from_now }
    region { 'Av. Paulista, 1000' }
    headhunter
  end
end
