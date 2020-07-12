# frozen_string_literal: true

class ProposalsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_headhunter!, only: %i[new create]
  before_action :authenticate_candidate!, only: %i[accept save_accept
                                                   reject save_reject]
  before_action :validate_profile!, only: %i[index accept save_accept
                                             reject save_reject]

  before_action :find_proposal_by_id, only: %i[show reject save_reject
                                               accept save_accept]
  before_action :find_registered_by_id, only: %i[new create]

  before_action :authenticate_proposal, only: %i[show reject save_reject accept
                                                 save_accept]

  def index
    if candidate_signed_in?
      @proposals = Proposal.all_candidate_proposal(current_candidate.id)
    else
      @proposals = Proposal.all_headhunter_proposal(:job_vacancy,
                                                    current_headhunter.id)
    end
  end

  def show
    @job_vacancy = @proposal.registered.job_vacancy
    @profile = @proposal.registered.candidate.profile
  end

  def new
    @proposal = @registered.build_proposal

    @minimum = @registered.job_vacancy.minimum_wage
    @maximum = @registered.job_vacancy.maximum_wage
  end

  def create
    @proposal = @registered.build_proposal(params_proposal)

    if @proposal.save
      @registered.proposal!

      ProposalMailer.received_proposal(@proposal.id)

      redirect_to candidate_list_job_vacancy_path(@registered.job_vacancy.id),
                  notice: t('.success', name: @registered.candidate.profile.name)
    else
      @minimum = @registered.job_vacancy.minimum_wage
      @maximum = @registered.job_vacancy.maximum_wage

      render :new
    end
  end

  def reject
    @job_vacancy = @proposal.registered.job_vacancy
  end

  def save_reject
    feedback = params[:proposal][:feedback]

    if feedback.blank?
      @proposal.update(feedback: 'Proposta rejeitada pelo candidato')
    else
      @proposal.update(feedback: feedback)
    end

    @proposal.rejected!
    @proposal.registered.reject_proposal!

    redirect_to @proposal, notice: t('.success', name: @proposal.registered
                                                                .candidate
                                                                .profile.name)
  end

  def accept
    @job_vacancy = @proposal.registered.job_vacancy
  end

  def save_accept
    if params[:confirm] == 'unchecked'
      @job_vacancy = @proposal.registered.job_vacancy

      flash[:alert] = 'É necessario confirmar a data de inicio das atividades.'
      redirect_to accept_proposal_path(@proposal)
    else
      if params[:proposal][:feedback].blank?
        @proposal.update(feedback: 'Proposta aceita pelo candidato')
      else
        @proposal.update(feedback: params[:proposal][:feedback])
      end

      @proposal.accepted!
      @proposal.registered.accept_proposal!

      Registered.where('candidate_id = ? and status = 0 or status = 10', current_candidate.id).each do |registered|
        registered.reject_proposal!
        registered.update(closed_feedback: 'Um candidato já foi selecionado para essa vaga')

        registered.proposal.destroy if registered.proposal.present?
      end

      flash[:notice] = 'Proposta aceita com sucesso. Parabéns!'

      redirect_to @proposal
    end
  end

  private

  def params_proposal
    params.require(:proposal).permit(:salary, :start_date, :limit_feedback_date, :benefits, :note)
  end

  def find_proposal_by_id
    @proposal = Proposal.find(params[:id])
  end

  def find_registered_by_id
    @registered = Registered.find(params[:id])
  end

  def authenticate_proposal
    return unless candidate_signed_in? || headhunter_signed_in?

    if candidate_signed_in?
      redirect_to root_path unless @proposal.candidate_proposal?(current_candidate.id)
    else
      redirect_to root_path unless @proposal.headhunter_proposal?(current_headhunter.id)
    end
  end
end
