# frozen_string_literal: true

class Registered < ApplicationRecord
  belongs_to :candidate
  belongs_to :job_vacancy

  has_one :proposal, dependent: :destroy

  delegate :headhunter_id, :minimum_wage, :maximum_wage, :vacancy_description,
           to: :job_vacancy
  delegate :feedback, to: :proposal

  validates :registered_justification, presence: true

  enum highlight: { unchecked: 0, checked: 1 }

  enum status: { in_progress: 0, closed: 5,
                 proposal: 10, reject_proposal: 15,
                 accept_proposal: 20, excluded: 30 }

  scope :candidate_registereds, lambda { |candidate_id|
    where('candidate_id = ?', candidate_id)
      .where(status: [0, 10])
  }

  def favorite_candidate
    checked? ? unchecked! : checked!
    highlight
  end

  def canceled_registered(justification)
    update(closed_feedback: justification)
    unchecked!
    excluded!
  end
end
