class HomeController < ApplicationController
  def index
    if current_candidate.present?
      profile = current_candidate.profile

      if profile.present?
        unless profile.profile_is_complete?
          flash[:alert] = 'É necessario completar o perfil para se inscrever em qualquer vaga'
          redirect_to edit_profile_path(profile)
        end
      else 
        flash[:alert] = 'É necessario criar um perfil para se inscrever em qualquer vaga'
        redirect_to new_profile_path
      end      
    end
  end
end
