class Comment < ApplicationRecord
  belongs_to :profile
  belongs_to :headhunter

  validates :comment, presence: true


  def heading
    "Headhunter: #{headhunter.email}"
  end

  def customized_send_time_message
    "Enviada em: #{I18n.localize created_at, format: :long}" 
  end


end
