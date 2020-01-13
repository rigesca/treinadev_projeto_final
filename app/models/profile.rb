class Profile < ApplicationRecord
  belongs_to :candidate
  has_many :comments

  has_one_attached :candidate_photo

  validates :name, :birth_date, presence: true

  def profile_is_complete?
    if (name.present? && social_name.present? && birth_date.present? &&
        formation.present? && description.present? && experience.present? &&
        candidate_photo.attached?)
      true 
    else 
      false
    end
  end    

  def calculates_candidate_age
    "#{Date.current.year - birth_date.year} Anos"
  end

end
