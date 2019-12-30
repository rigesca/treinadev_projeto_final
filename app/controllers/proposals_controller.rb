class ProposalsController < ApplicationController

    before_action :authenticate_headhunter!, only: [:new,:create]

    def index

        if current_candidate.present?
            @proposals = Proposal.joins(:registered).where('registereds.candidate_id = ?', current_candidate.id).submitted
        else
            @proposals = Proposal.joins(registered: [:job_vacancy]).where('job_vacancies.headhunter_id = ?', current_headhunter.id)
        end
            
    end

    def show
        @proposal = Proposal.find(params[:id])
        @job_vacancy = @proposal.registered.job_vacancy
        @profile = @proposal.registered.candidate.profile
    end

    def new
        @registered = Registered.find(params[:id])
        @proposal = @registered.build_proposal

        @minimum = @registered.job_vacancy.minimum_wage
        @maximum = @registered.job_vacancy.maximum_wage
    end

    def create
        @registered = Registered.find(params[:id])
        @proposal = @registered.build_proposal(params_proposal)

        if @proposal.save
            @registered.proposal!
            
            flash[:notice] = "Proposta enviada ao candidato #{@registered.candidate.profile.name} com sucesso"

            redirect_to candidate_list_job_vacancy_path(@registered.job_vacancy.id)
        else 
            @minimum = @registered.job_vacancy.minimum_wage
            @maximum = @registered.job_vacancy.maximum_wage
            
            render :new
        end        
    end

    def reject
        @proposal = Proposal.find(params[:id])
        @job_vacancy = @proposal.registered.job_vacancy
    end

    def save_reject
        @proposal = Proposal.find(params[:id])

        if params[:proposal][:feedback].blank?
            @proposal.update(feedback: "Proposta rejeitada pelo candidato")
        else
            @proposal.update(feedback: params[:proposal][:feedback])
        end
        
        @proposal.rejected!
        @proposal.registered.reject_proposal!

        flash[:notice] = "Proposta rejeitada pelo candidato #{@proposal.registered.candidate.profile.name}, feedback sera enviado ao headhunter"
        
        redirect_to @proposal
    end

    def accept
        @proposal = Proposal.find(params[:id])
        @job_vacancy = @proposal.registered.job_vacancy
    end

    def save_accept
        @proposal = Proposal.find(params[:id])
        
        if params[:confirm] == 'unchecked'
            @job_vacancy = @proposal.registered.job_vacancy

            flash[:alert] = "É necessario confirmar a data de inicio das atividades."
            redirect_to accept_proposal_path(@proposal)
        else
            if params[:proposal][:feedback].blank?
                @proposal.update(feedback: "Proposta aceita pelo candidato")
            else
                @proposal.update(feedback: params[:proposal][:feedback])
            end
            
            @proposal.accepted!
            @proposal.registered.accept_proposal!

         
            Registered.where('candidate_id = ? and status = 0 or status = 10', current_candidate.id).each do |registered|
                registered.reject_proposal!
                registered.update(closed_feedback: "Candidato aceitou outra proposta")
                
                if registered.proposal.present? 
                    if registered.proposal.submitted?
                        registered.proposal.rejected!
                        registered.proposal.update(feedback: "Candidato aceitou outra proposta")
                    end
                end
            end
    
            flash[:notice] = "Proposta aceita com sucesso. Parabéns!"
            
            redirect_to @proposal
        end
    end

    private 

    def params_proposal
        params.require(:proposal).permit(:salary, :start_date, :limit_feedback_date, :benefits, :note)
    end

end