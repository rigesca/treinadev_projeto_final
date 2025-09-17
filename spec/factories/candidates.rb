# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :candidate do
    sequence(:email) { |n| "candidate#{n}@email.com" }
    password { '12345678' }
  end

  trait :with_profile do
    after(:create) do |candidate|
      create(:profile, :with_photo, candidate: candidate)
    end
  end
end
