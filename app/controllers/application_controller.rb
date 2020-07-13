# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authenticate_user!
    redirect_to root_path unless headhunter_signed_in? || candidate_signed_in?
  end

  def validate_profile!
    return unless candidate_signed_in?

    if current_candidate.profile.blank?
      redirect_to new_profile_path(current_candidate.profile),
                  notice: t('message.blank_profile')
    else
      unless current_candidate.profile.complete?
        redirect_to edit_profile_path(current_candidate.profile),
                    notice: t('message.incomplete_profile')
      end
    end
  end
end
