require 'ffaker'

FactoryBot.define do 
    factory :profile do
        name { FFaker::NameBR.name }
        social_name { name }
        birth_date {FFaker::Time.between('1970-01-01 16:20', '2015-01-01 16:20')}
        formation {'Formado na Faculdade da cidade, no curso ciências da computação.'}
        description {'Busco oportunidade como programador'}
        experience {'Trabalhou por 2 anos na empresa X'}
        candidate_photo { File.new("#{Rails.root}/spec/support/foto.jpeg")}
        candidate 
    end
end