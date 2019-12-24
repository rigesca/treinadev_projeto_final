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

    def cancel
        @registered = Registered.find(params[:id])
        @profile = @registered.candidate.profile
        @job_vacancy = @registered.job_vacancy
    end

    def save_canceled
        @registered = Registered.find(params[:id])
        justification = params[:registered][:closed_feedback]

        if justification.present?
            @registered.update(closed_feedback: justification) 
            
            @registered.unchecked!
            @registered.closed!

            flash[:notice] = "Candidato #{@registered.candidate.profile.name} teve sua participação finalizada com sucesso"
            redirect_to candidate_list_job_vacancy_path(@registered.job_vacancy.id)
        else
            flash[:alert] = "Campo Feedback não pode ser vazio"

            redirect_to cancel_registered_path(@registered)
        end
    end
end

