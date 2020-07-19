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
    if @registered.favorite_candidate == 'checked'
      flash[:notice] = t('.candidate_check', name: @registered.candidate
                                                              .name)
    else
      flash[:alert] = t('.candidate_uncheck', name: @registered.candidate
                                                               .name)
    end
    redirect_to candidate_list_job_vacancy_path(@registered.job_vacancy.id)
  end

  def cancel
    @profile = @registered.candidate.profile
    @job_vacancy = @registered.job_vacancy
  end

  def save_canceled
    if params[:registered][:closed_feedback].present?
      @registered.canceled_registered(params[:registered][:closed_feedback])

      redirect_to candidate_list_job_vacancy_path(@registered.job_vacancy.id),
                  notice: t('.finished', name: @registered.candidate
                                                          .name)
    else
      redirect_to cancel_registered_path(@registered),
                  alert: t('.feedback_not_blank')
    end
  end

  protected

  def find_registereds_by_id
    @registered = Registered.find(params[:id])
  end
end
