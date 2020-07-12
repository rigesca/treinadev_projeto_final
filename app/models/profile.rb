# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :candidate
  has_many :comments, dependent: :destroy

  has_one_attached :candidate_photo

  validates :name, :birth_date, presence: true

  def complete?
    social_name.present? && formation.present? &&
      description.present? && experience.present? &&
      candidate_photo.attached?
  end

  def calculates_candidate_age
    "#{Date.current.year - birth_date.year} Anos"
  end
end
