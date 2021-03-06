# frozen_string_literal: true

FactoryBot.define do
  factory :registered do
    candidate
    job_vacancy
    registered_justification do
      'Estou preparado para exercer esse cargo na empresa'
    end
  end
end
