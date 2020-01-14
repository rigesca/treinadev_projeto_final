class ApplicationController < ActionController::Base

    def authenticate_user!
        redirect_to root_path unless current_candidate.present? || current_headhunter.present?
    end
end
