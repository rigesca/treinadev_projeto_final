require 'ffaker'

FactoryBot.define do 
    factory :profile do
        candidate
        name { FFaker::NameBR.name }
        social_name { name }
        birth_date {FFaker::Time.between('1970-01-01 16:20', '2015-01-01 16:20') }
        formation {'Formado na Faculdade da cidade, no curso ciências da computação.' }
        description {'Busco oportunidade como programador' }
        experience {'Trabalhou por 2 anos na empresa X' }


        trait :with_photo do 
          after :create do |profile|
          profile.candidate_photo.attach(
              io: File.open(Rails.root.join('spec', 'support', 'foto.jpeg')),
              filename:'foto.jpeg')
          end
        end
    end
end
