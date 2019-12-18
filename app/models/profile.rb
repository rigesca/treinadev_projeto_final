class Profile < ApplicationRecord
  belongs_to :candidate

  validates :name, presence: true

  def profile_is_complete?
    if (name.present? && social_name.present? && birth_date.present?
        formation.present? && description.present? && experience.present?)
      true
    else 
      false
    end
  end    

end
