# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:profile) }
    it { should belong_to(:headhunter) }
  end

  describe 'validation' do
    it { should validate_presence_of(:comment) }
  end
end
