class JobVacanciesController < ApplicationController

    before_action :authenticate_headhunter!, only: [:new,:create]



    def index
        @job_vacancies = JobVacancy.where(headhunter_id: current_headhunter.id)        
    end

    def show
        @job_vacancy = JobVacancy.find(params[:id])
    end

    def new
        @job_vacancy = JobVacancy.new
    end

    def create
        @job_vacancy = JobVacancy.new(params_job_vacancy)
        @job_vacancy.headhunter_id = current_headhunter.id
        if @job_vacancy.save()
            flash[:notice] = "Vaga criada com sucesso."
            redirect_to @job_vacancy
        else
            render :new
        end
    end







    private

    def params_job_vacancy
        params.require(:job_vacancy).permit(:title, :vacancy_description, :ability_description,
                                            :maximum_wage, :minimum_wage, :level, :limit_date,
                                            :region)
    end

end