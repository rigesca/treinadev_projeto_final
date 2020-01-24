require 'ffaker'

FactoryBot.define do 
    factory :comment do
        profile
        headhunter 
        comment {"Bom dia #{profile.name}, gostariamos de agendar uma entrevista com você, entre em contato no telefone 1812-5142"}
    end
end