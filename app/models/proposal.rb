# frozen_string_literal: true

class Proposal < ApplicationRecord
  belongs_to :registered

  validates :start_date, :limit_feedback_date,
            :salary, :benefits, presence: true
  validates :salary, numericality: true

  validate :start_date_must_be_greater_than_today
  validate :salary_must_be_between_the_maximum_and_minimum_wage_values
  validate :limit_date_must_be_between_today_and_start_date

  enum status: { submitted: 0, accepted: 10, rejected: 20, expired: 30 }

  protected

  def start_date_must_be_greater_than_today
    return if start_date.blank?

    return unless start_date <= Date.current

    errors.add(:start_date, 'deve ser maior que a data atual.')
  end

  def salary_must_be_between_the_maximum_and_minimum_wage_values
    return if salary.blank?

    if salary < registered.job_vacancy.minimum_wage ||
       salary > registered.job_vacancy.maximum_wage
      errors.add(
        :salary, 'o valor deve estra dentro da faixa estipulado pela vaga.'
      )
    end
  end

  def limit_date_must_be_between_today_and_start_date
    return unless limit_feedback_date.present? && start_date.present?

    if limit_feedback_date <= Date.current
      errors.add(:limit_feedback_date, 'deve ser maior que a data atual.')
    elsif limit_feedback_date >= start_date
      errors.add(:limit_feedback_date, 'deve ser menor que a data de inicio'\
        ' das atividades.')
    end
  end
end
