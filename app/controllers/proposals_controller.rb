class ProposalsController < ApplicationController

    def new
        @registered = Registered.find(params[:id])
        @proposal = @registered.build_proposal
    end

    def create
        @registered = Registered.find(params[:id])
        @proposal = @registered.build_proposal(params_proposal)

        if @proposal.save
            flash[:notice] = "Proposta enviada ao candidato #{@registered.candidate.profile.name} com sucesso"

            redirect_to candidate_list_job_vacancy_path(@registered.job_vacancy.id)
        else 
            render :new
        end        
    end

    private 

    def params_proposal
        params.require(:proposal).permit(:start_date, :salary, :benefits, :note)
    end

end