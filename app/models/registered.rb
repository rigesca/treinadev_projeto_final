class Registered < ApplicationRecord
  belongs_to :candidate
  belongs_to :job_vacancy

  belongs_to :proposal, optional: true

  has_one :proposal

  validates :registered_justification, presence: true

  enum highlight: {unchecked: false , checked: true}

  enum status: {in_progress: 0,
                closed: 5}

end
