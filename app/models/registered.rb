# frozen_string_literal: true

class Registered < ApplicationRecord
  belongs_to :candidate
  belongs_to :job_vacancy

  has_one :proposal, dependent: :destroy

  validates :registered_justification, presence: true

  enum highlight: { unchecked: 0, checked: 1 }

  enum status: { in_progress: 0, closed: 5,
                 proposal: 10, reject_proposal: 15,
                 accept_proposal: 20, excluded: 30 }
end
