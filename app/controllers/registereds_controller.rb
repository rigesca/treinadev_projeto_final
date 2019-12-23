class RegisteredsController < ApplicationController

    def index
        @registereds = Registered.where(candidate_id: current_candidate)
    end

    def mark
        registered = Registered.find(params[:id])
        if registered.checked?
            flash[:alert] = "Candidato #{registered.candidate.profile.name} desmarcado como destaque com sucesso"
            registered.unchecked!
        else 
            flash[:notice] = "Candidato #{registered.candidate.profile.name} marcado como destaque com sucesso"
            registered.checked!
        end
        
        redirect_to candidate_list_job_vacancy_path(registered.job_vacancy.id)  
    end

end

