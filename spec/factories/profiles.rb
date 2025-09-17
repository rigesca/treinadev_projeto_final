# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :profile do
    candidate
    name { FFaker::NameBR.name }
    social_name { name }
    birth_date { FFaker::Time.between('1970-01-01 16:20', '2015-01-01 16:20') }
    formation do
      "Formado na Faculdade de #{FFaker::NameBR.name}, no curso ciências da computação."
    end
    description { 'Busco oportunidade como programador' }
    experience { "Trabalhou por 2 anos na empresa #{FFaker::Company.name}." }

    trait :with_photo do
      image_path = Rails.root.join('spec/support/foto.jpeg')
      candidate_photo { fixture_file_upload(image_path, 'image/jpeg') }
    end
  end
end
