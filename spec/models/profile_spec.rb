# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'associations' do
    it { should belong_to(:candidate) }
    it { should have_many(:comments) }
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:birth_date) }
  end

  context '.is_complete?' do
    it 'with a complete profile' do
      profile = create(:profile, :with_photo)

      expect(profile.is_complete?).to eq(true)
    end

    it 'with a incomplete profile' do
      profile = create(:profile, :with_photo, description: '',
                                              experience: '')

      expect(profile.is_complete?).to eq(false)
    end

    it 'withou a photo' do
      profile = create(:profile)

      expect(profile.is_complete?).to eq(false)
    end
  end
end
