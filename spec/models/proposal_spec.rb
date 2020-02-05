# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Proposal, type: :model do
  describe 'associations' do
    it { should belong_to(:registered) }
  end

  describe 'validation' do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:limit_feedback_date) }
    it { should validate_presence_of(:salary) }
    it { should validate_presence_of(:benefits) }
  end

  context '.start_date_must_be_greater_than_today' do
    it 'start date must exist' do
      proposal = build(:proposal, start_date: '')
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Data inicial não pode ficar em branco'
      )
    end

    it 'start date bigger than today' do
      proposal = build(:proposal, start_date: Date.current.next_day(15),
                                  limit_feedback_date: 7.days.from_now)
      proposal.valid?

      expect(proposal.errors.full_messages).to be_empty
    end

    it 'start date equal today' do
      proposal = build(:proposal, start_date: Date.current,
                                  limit_feedback_date: 7.days.from_now)
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Data inicial deve ser maior que a data atual.'
      )
    end

    it 'start date less than today' do
      proposal = build(:proposal, start_date: Date.current.prev_day(15),
                                  limit_feedback_date: 7.days.from_now)
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Data inicial deve ser maior que a data atual.'
      )
    end
  end

  context '.salary_must_be_between_the_maximum_and_minimum_wage_values' do
    it 'salary must exist' do
      proposal = build(:proposal, salary: '')
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Salário não pode ficar em branco'
      )
    end

    it 'salary must be between minimum and maximum wage' do
      job_vacancy = create(:job_vacancy, minimum_wage: 2500,
                                         maximum_wage: 3200)

      registered = create(:registered, job_vacancy_id: job_vacancy.id)

      proposal = build(:proposal, salary: 2850, registered: registered)
      proposal.valid?

      expect(proposal.errors.full_messages).to be_empty
    end

    it 'salary must be equal to minimum wage' do
      job_vacancy = create(:job_vacancy, minimum_wage: 2500,
                                         maximum_wage: 3200)

      registered = create(:registered, job_vacancy_id: job_vacancy.id)

      proposal = build(:proposal, salary: 2500, registered: registered)
      proposal.valid?

      expect(proposal.errors.full_messages).to be_empty
    end

    it 'salary must be equal to maximum wage' do
      job_vacancy = create(:job_vacancy, minimum_wage: 2500,
                                         maximum_wage: 3200)

      registered = create(:registered, job_vacancy_id: job_vacancy.id)

      proposal = build(:proposal, salary: 3200, registered: registered)
      proposal.valid?

      expect(proposal.errors.full_messages).to be_empty
    end

    it 'salary must be less than minimum wage' do
      job_vacancy = create(:job_vacancy, minimum_wage: 2500,
                                         maximum_wage: 3200)

      registered = create(:registered, job_vacancy_id: job_vacancy.id)

      proposal = build(:proposal, salary: 1500, registered: registered)
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Salário o valor deve estra dentro da faixa estipulado pela vaga.'
      )
    end

    it 'salary must be bigger than maximun wage' do
      job_vacancy = create(:job_vacancy, minimum_wage: 2500,
                                         maximum_wage: 3200)

      registered = create(:registered, job_vacancy_id: job_vacancy.id)

      proposal = build(:proposal, salary: 3500, registered: registered)
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Salário o valor deve estra dentro da faixa estipulado pela vaga.'
      )
    end
  end

  context '.limit_date_must_be_between_today_and_start_date' do
    it 'limit date must exist' do
      proposal = build(:proposal, limit_feedback_date: '')
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Data limite para resposta não pode ficar em branco'
      )
    end

    it 'limit date must be between today and start date' do
      proposal = build(:proposal, start_date: 14.days.from_now,
                                  limit_feedback_date: 7.days.from_now)
      proposal.valid?

      expect(proposal.errors.full_messages).to be_empty
    end

    it 'limit date less than today date' do
      proposal = build(:proposal, start_date: 15.days.from_now,
                                  limit_feedback_date: Date.current.prev_day(7))
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Data limite para resposta deve ser maior que a data atual.'
      )
    end

    it 'limit date equal today' do
      proposal = build(:proposal, start_date: 15.days.from_now,
                                  limit_feedback_date: Date.current)
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Data limite para resposta deve ser maior que a data atual.'
      )
    end

    it 'limit date bigger than start date' do
      proposal = build(:proposal, start_date: 15.days.from_now,
                                  limit_feedback_date: 30.days.from_now)
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Data limite para resposta deve ser menor que a data de inicio das atividades.'
      )
    end

    it 'limit date equal start date' do
      proposal = build(:proposal, start_date: 15.days.from_now,
                                  limit_feedback_date: 15.days.from_now)
      proposal.valid?

      expect(proposal.errors.full_messages).to include(
        'Data limite para resposta deve ser menor que a data de inicio das atividades.'
      )
    end
  end
end
