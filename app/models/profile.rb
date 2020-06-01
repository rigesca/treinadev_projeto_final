# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :candidate
  has_many :comments, dependent: :destroy

  has_one_attached :candidate_photo

  validates :name, :birth_date, presence: true

  def profile_is_complete?
    return true if social_name.present? && formation.present? &&
                   description.present? && experience.present? &&
                   candidate_photo.attached?

    false
  end

  def calculates_candidate_age
    "#{Date.current.year - birth_date.year} Anos"
  end
end
