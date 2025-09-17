# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    profile
    headhunter
    comment do
      "Bom dia #{profile.name}, gostariamos de agendar uma entrevistacom você, entre em contato no telefone 1812-5142"
    end
  end
end
