class ProfilesController < ApplicationController

    before_action :authenticate_candidate!, only: [:new,:create,:edit,:update]


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
            redirect_to root_path
        else 
            render :edit
        end
    end

    private 

    def profile_params
        params.require(:profile).permit(:name, :social_name, :birth_date, 
                                        :formation, :description, :experience)
    end
end
