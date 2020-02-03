# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobVacancy, type: :model do
  describe 'associations' do
    it { should belong_to(:headhunter) }
    it { should have_many(:candidates) }
    it { should have_many(:registereds) }
  end

  describe 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:vacancy_description) }
    it { should validate_presence_of(:ability_description) }
    it { should validate_presence_of(:level) }
    it { should validate_presence_of(:limit_date) }
    it { should validate_presence_of(:region) }
    it { should validate_numericality_of(:maximum_wage) }
    it {
      should validate_numericality_of(
        :minimum_wage
      ).is_greater_than_or_equal_to(0)
    }
  end

  context '.maximun_wage_not_be_greater_than_minimum' do
    it 'minimum wage less than maximo wage' do
      job_vacancy = build(:job_vacancy, minimum_wage: 2500,
                                        maximum_wage: 2800)
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to be_empty
    end

    it 'minimum and maximun wage must be equal' do
      job_vacancy = build(:job_vacancy, minimum_wage: 2500,
                                        maximum_wage: 2500)
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to be_empty
    end

    it 'minimum wage bigger than maximo wage' do
      job_vacancy = build(:job_vacancy, minimum_wage: 2800,
                                        maximum_wage: 2500)
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include(
        'Valor minimo deve ser menor que o valor maximo.'
      )
    end

    it 'minimum wage must exist' do
      job_vacancy = build(:job_vacancy, minimum_wage: nil)
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include(
        'Valor minimo não é um número'
      )
    end

    it 'maximum wage must exist' do
      job_vacancy = build(:job_vacancy, maximum_wage: nil)
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include(
        'Valor maximo não é um número'
      )
    end

    it 'minimum wage below zero' do
      job_vacancy = build(:job_vacancy, minimum_wage: -100,
                                        maximum_wage: 2500)
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include(
        'Valor minimo deve ser maior ou igual a 0'
      )
    end
  end

  context '.limit_date_must_be_greater_than_today' do
    it 'limit date bigger than today' do
      job_vacancy = build(:job_vacancy, limit_date: 7.day.from_now)
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to be_empty
    end

    it 'limit date equal today' do
      job_vacancy = build(:job_vacancy, limit_date: Date.today)
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include(
        'Data limite para inscrições deve ser maior que a data atual.'
      )
    end

    it 'limit date less than today' do
      job_vacancy = build(:job_vacancy, limit_date: Date.today.prev_day(7))
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include(
        'Data limite para inscrições deve ser maior que a data atual.'
      )
    end

    it 'limit date must exist' do
      job_vacancy = build(:job_vacancy, limit_date: nil)
      job_vacancy.valid?

      expect(job_vacancy.errors.full_messages).to include(
        'Data limite para inscrições não pode ficar em branco'
      )
    end
  end

  context '.verify_status_registered_for_vacancy' do
    it 'for a candidate with registered in progress' do
      candidate = create(:candidate)
      vacancy = create(:job_vacancy)
      create(:registered, candidate_id: candidate.id,
                          job_vacancy_id: vacancy.id)

      expect(
        vacancy.verify_status_registered_for_vacancy(candidate.id)
      ).to eq(true)
    end

    it 'for a candidate with registered proposal' do
      candidate = create(:candidate)
      vacancy = create(:job_vacancy)
      create(:registered, candidate_id: candidate.id,
                          job_vacancy_id: vacancy.id,
                          status: :proposal)

      expect(
        vacancy.verify_status_registered_for_vacancy(candidate.id)
      ).to eq(false)
    end

    it 'for a candidate with registered reject proposal' do
      candidate = create(:candidate)
      vacancy = create(:job_vacancy)
      create(:registered, candidate_id: candidate.id,
                          job_vacancy_id: vacancy.id,
                          status: :reject_proposal)

      expect(
        vacancy.verify_status_registered_for_vacancy(candidate.id)
      ).to eq(false)
    end

    it 'for a candidate with registered accept proposal' do
      candidate = create(:candidate)
      vacancy = create(:job_vacancy)
      create(:registered, candidate_id: candidate.id,
                          job_vacancy_id: vacancy.id,
                          status: :accept_proposal)

      expect(
        vacancy.verify_status_registered_for_vacancy(candidate.id)
      ).to eq(false)
    end

    it 'for a candidate with registered excluded' do
      candidate = create(:candidate)
      vacancy = create(:job_vacancy)
      create(:registered, candidate_id: candidate.id,
                          job_vacancy_id: vacancy.id,
                          status: :excluded)

      expect(
        vacancy.verify_status_registered_for_vacancy(candidate.id)
      ).to eq(false)
    end

    it 'for a candidate with registered closed' do
      candidate = create(:candidate)
      vacancy = create(:job_vacancy)
      create(:registered, candidate_id: candidate.id,
                          job_vacancy_id: vacancy.id,
                          status: :reject_proposal)

      expect(
        vacancy.verify_status_registered_for_vacancy(candidate.id)
      ).to eq(false)
    end
  end
end
