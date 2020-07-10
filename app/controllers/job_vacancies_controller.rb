# frozen_string_literal: true

class JobVacanciesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_candidate!, only: %i[apply search]
  before_action :authenticate_headhunter!,
                only: %i[new create candidate_list closes]

  before_action :validate_profile!, only: %i[index apply search]

  before_action :find_job_vacancy, only: %i[show apply candidate_list closes]

  def index
    @job_vacancies =
      if headhunter_signed_in?
        JobVacancy.where(headhunter_id: current_headhunter.id)
      else
        JobVacancy.available_vacancy
      end
  end

  def show
    if candidate_signed_in?
      @registered = Registered.new
    else
      @registereds = Registered.where(job_vacancy_id: @job_vacancy)
                               .accept_proposal
    end
  end

  def new
    @job_vacancy = JobVacancy.new
  end

  def create
    @job_vacancy = JobVacancy.new(params_job_vacancy)
    @job_vacancy.headhunter_id = current_headhunter.id
    if @job_vacancy.save
      redirect_to @job_vacancy, notice: t('message.success')
    else
      render :new
    end
  end

  def search
    @job_vacancies = JobVacancy.available_vacancy

    @job_vacancies = @job_vacancies.word_search(params[:q]) if params[:q].present?
    @job_vacancies = @job_vacancies.where(level: params[:levels]) if params[:levels].present?
    @job_vacancies = @job_vacancies.minimum_wage(params[:minimun]) if params[:minimun].present?

    render :index
  end

  def apply
    @registered =
      Registered.new(candidate_id: current_candidate.id,
                     job_vacancy_id: @job_vacancy.id,
                     registered_justification:
                        params[:registered][:registered_justification])
    if @registered.save
      flash[:notice] = "Você se escreveu para a vaga: #{@job_vacancy.title}, "\
                       'com sucesso'
    else
      flash[:alert] = @registered.errors.full_messages.first
    end

    redirect_to @job_vacancy
  end

  def candidate_list
    @registereds = @job_vacancy.registereds.where('registereds.status <> 5')
    @favorits_registereds = @registereds.checked
    @canceled_registereds = @job_vacancy.registereds.excluded
  end

  def closes
    registereds =
      Registered.where(status: %i[in_progress proposal reject_proposal])
                .where(job_vacancy_id: @job_vacancy.id)

    registereds.each do |registered|
      registered.closed!
      registered.proposal.destroy if registered.proposal.present?
    end

    @job_vacancy.closed!

    redirect_to @job_vacancy
  end

  private

  def find_job_vacancy
    @job_vacancy = JobVacancy.find(params[:id])
  end

  def params_job_vacancy
    params.require(:job_vacancy)
          .permit(:title, :vacancy_description, :ability_description,
                  :maximum_wage, :minimum_wage, :level, :limit_date,
                  :region)
  end
end
