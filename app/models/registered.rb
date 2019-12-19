class Registered < ApplicationRecord
  belongs_to :candidate
  belongs_to :job_vacancy

  validates :registered_justification, presence: true
end
