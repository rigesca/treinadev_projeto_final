require 'ffaker'

FactoryBot.define do 
    factory :headhunter do
        email {FFaker::Internet.email}
        password {'12345678'}     
    end
end