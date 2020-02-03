# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Candidate, type: :model do
  describe 'associations' do
    it { should have_one(:profile) }
    it { should have_many(:registereds) }
    it { should have_many(:job_vacancies) }
  end
end
