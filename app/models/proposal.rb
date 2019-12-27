class Proposal < ApplicationRecord
    has_one :registered

    validates :start_date,:salary,:benefits, presence: true
    validates :salary, numericality: true

    validate :start_date_must_be_greater_than_today
    validate :salary_must_be_between_the_maximum_and_minimum_wage_values


    protected

    def start_date_must_be_greater_than_today
        return unless start_date.present?

        if start_date <= Date.current
          errors.add(:start_date, 'deve ser maior que a data atual.')
        end
    end

    def salary_must_be_between_the_maximum_and_minimum_wage_values
        return unless salary.present?

        if salary < registered.job_vacancy.minimum_wage ||
            salary > registered.job_vacancy.maximum_wage
            errors.add(:salary, 'o valor deve estra dentro da faixa estipulado pela vaga.')
        end
    end





end
