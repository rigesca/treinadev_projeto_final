class ApplicationController < ActionController::Base

    def authenticate_usser!
        redirect_to root_path unless current_candidate.present? || current_headhunter.present?
    end
end
