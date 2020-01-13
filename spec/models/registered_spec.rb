require 'rails_helper'

RSpec.describe Registered, type: :model do

    describe 'associations' do
        it { should belong_to(:candidate)}
        it { should belong_to(:job_vacancy)}
        it { should have_one(:proposal)}
    end

    describe 'validation' do
        it { should validate_presence_of(:registered_justification)}
    end
end
