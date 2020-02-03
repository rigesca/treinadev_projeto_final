# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Headhunter, type: :model do
  describe 'associations' do
    it { should have_many(:job_vacancy) }
    it { should have_many(:comments) }
  end
end
