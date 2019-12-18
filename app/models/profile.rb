class Profile < ApplicationRecord
  belongs_to :candidate

  has_one_attached :candidate_photo

  validates :name, presence: true

  def profile_is_complete?
    if (name.present? && social_name.present? && birth_date.present? &&
        formation.present? && description.present? && experience.present? &&
        candidate_photo.attached?)
      true
    else 
      false
    end
  end    

end
