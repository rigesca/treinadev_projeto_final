# frozen_string_literal: true

FactoryBot.define do
  factory :proposal do
    salary { 2600 }
    start_date { 20.days.from_now }
    limit_feedback_date { 15.days.from_now }
    benefits { 'Vale transporte, vale refeição, plano de saude.' }
    registered
  end
end
