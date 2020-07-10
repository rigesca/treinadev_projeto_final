# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_candidate!, only: %i[new create edit update]
  before_action :authenticate_headhunter!, only: [:register_comment]

  before_action :validate_profile!, only: [:comments_list]

  before_action :find_profile, only: %i[show edit update]

  def new
    @profile = Profile.new
  end

  def show; end

  def edit; end

  def create
    @profile = Profile.new(profile_params)
    @profile.candidate_id = current_candidate.id

    if @profile.save
      flash[:notice] =
        @profile.is_complete? ? t('message.concluded') : t('message.success')
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: t('message.update')
    else
      render :edit
    end
  end

  def comments_list
    if current_headhunter.present?
      @candidate_comments = current_headhunter.comments
                                              .where(profile_id: params[:id])
      @comment = Comment.new
    else
      @candidate_comments = Profile.find(params[:id]).comments
    end
  end

  def register_comment
    @comment = Comment.new(headhunter_id: current_headhunter.id,
                           profile_id: params[:id],
                           comment: params[:comment][:comment])

    if @comment.save
      flash[:notice] = t('message.comment_created')
    else
      flash[:alert] = @comment.errors.full_messages.first
    end

    redirect_to comments_list_profile_path
  end

  private

  def find_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:name, :social_name, :birth_date,
                                    :formation, :description, :experience, :candidate_photo)
  end
end
