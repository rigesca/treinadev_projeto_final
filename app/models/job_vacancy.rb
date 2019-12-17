class JobVacancy < ApplicationRecord
  belongs_to :headhunter

  validates :title, :vacancy_description, :ability_description, :level,
            :limit_date, :region, presence: true
  validates :minimum_wage, numericality: {greater_than_or_equal_to: 0}
  validates :maximum_wage, numericality: true

  validate :maximun_wage_not_be_greater_than_minimum
  validate :limit_date_must_be_greater_than_today

  enum level: { trainee: 0, junior: 10, full: 20, senior: 30,
                specialist: 40, manager: 50}
  enum status: { open: 0, closed: 10}

  protected 

  def maximun_wage_not_be_greater_than_minimum
    return unless maximum_wage.present? && minimum_wage.present?

    if minimum_wage > maximum_wage
      errors.add(:minimum_wage, 'deve ser menor que o valor maximo.')
    end
  end

  def limit_date_must_be_greater_than_today
    return unless limit_date.present?

    if limit_date <= Date.current
      errors.add(:limit_date, 'deve ser maior que a data atual.')
    end
  end


end
