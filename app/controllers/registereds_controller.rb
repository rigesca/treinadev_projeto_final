# frozen_string_literal: true

class RegisteredsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_headhunter!, only: %i[mark save_canceled cancel]

  before_action :validate_profile!, only: [:index]

  before_action :find_registereds_by_id, only: %i[mark cancel save_canceled]

  def index
    @registereds = Registered.where(candidate_id: current_candidate)
  end

  def mark
    if @registered.checked?
      flash[:alert] = t('message.candidate_uncheck', name: @registered.candidate
                                                                      .profile
                                                                      .name)
      @registered.unchecked!
    else
      flash[:notice] = t('message.candidate_check', name: @registered.candidate
                                                                     .profile
                                                                     .name)
      @registered.checked!
    end

    redirect_to candidate_list_job_vacancy_path(@registered.job_vacancy.id)
  end

  def cancel
    @profile = @registered.candidate.profile
    @job_vacancy = @registered.job_vacancy
  end

  def save_canceled
    justification = params[:registered][:closed_feedback]

    if justification.present?
      @registered.update(closed_feedback: justification)

      @registered.unchecked!
      @registered.excluded!

      redirect_to candidate_list_job_vacancy_path(@registered.job_vacancy.id),
                  notice: t('.message.finished', name: @registered.candidate
                                                                  .profile
                                                                  .name)
    else
      redirect_to cancel_registered_path(@registered),
                  alert: t('.error.feedback_not_blank')
    end
  end

  protected

  def find_registereds_by_id
    @registered = Registered.find(params[:id])
  end
end
