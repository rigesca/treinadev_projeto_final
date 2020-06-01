# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authenticate_user!
    unless current_candidate.present? || current_headhunter.present?
    redirect_to root_path
    end
  end

  def validate_profile!
    return if current_candidate.blank?

    if current_candidate.profile.blank?
      redirect_to new_profile_path(current_candidate.profile),
                  notice: t('message.blank_profile')
    else
      unless current_candidate.profile.profile_is_complete?
        redirect_to edit_profile_path(current_candidate.profile),
                    notice: t('message.incomplete_profile')
      end
    end
  end
end