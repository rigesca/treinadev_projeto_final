# frozen_string_literal: true

class Headhunter < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :job_vacancy, dependent: :destroy
  has_many :comments, dependent: :destroy
end
