class ProfilesController < ApplicationController

    before_action :authenticate_candidate!, only: [:new,:create,:edit,:update]
    before_action :validate_profile!, only: [:comments_list]

    before_action :authenticate_headhunter!, only: [:register_comment]
    
    before_action :authenticate_user!

    def new
        @profile = Profile.new
    end

    def show
        @profile = Profile.find(params[:id])
    end

    def edit
        @profile = Profile.find(params[:id])
    end

    def create
        @profile = Profile.new(profile_params)
        @profile.candidate_id = current_candidate.id

        if @profile.save
            if @profile.profile_is_complete?
                flash[:notice] = 'Perfil concluido com sucesso'
            else
                flash[:notice] = 'Perfil cadastrado com sucesso'
            end
            redirect_to root_path
        else 
            render :new
        end
    end

    def update
        @profile = Profile.find(params[:id])
        
        if @profile.update(profile_params)
            flash[:notice] = 'Perfil alterado com sucesso'
            redirect_to @profile
        else 
            render :edit
        end
    end

    def comments_list
        if current_headhunter.present?
            @candidate_comments = current_headhunter.comments.where(profile_id: params[:id])
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
            flash[:notice] = 'Comentário criado com sucesso'
            redirect_to comments_list_profile_path
        else
            flash[:alert] = @comment.errors.full_messages.first
            redirect_to comments_list_profile_path
        end
    end

    private 

    def profile_params
        params.require(:profile).permit(:name, :social_name, :birth_date, 
                                        :formation, :description, :experience, :candidate_photo)
    end
end
