require 'rails_helper'

RSpec.describe Profile, type: :model do
  context '.profile_is_complete?' do
    it 'with a complete profile' do
      candidate = Candidate.create!(email: 'candidate@teste.com',
                                    password: '123teste')
      profile = Profile.new(name: 'Fulano Da Silva', social_name: 'Siclano', 
                            birth_date: '15/07/1989',formation: 'Formado pela faculdade X',
                            description: 'Busco oportunidade como programador',
                            experience: 'Trabalhou por 2 anos na empresa X',
                            candidate_id: candidate.id)

      expect(profile.profile_is_complete?).to eq(true)
    end

    it 'with a incomplete profile' do
      candidate = Candidate.create!(email: 'candidate@teste.com',
                                    password: '123teste')
      profile = Profile.new(name: 'Fulano Da Silva', candidate_id: candidate.id)

      expect(profile.profile_is_complete?).to eq(false)
    end
  end
end
