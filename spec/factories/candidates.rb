require 'ffaker'

FactoryBot.define do 
    factory :candidate do
        email {FFaker::Internet.email}
        password {'12345678'}     
    end
end