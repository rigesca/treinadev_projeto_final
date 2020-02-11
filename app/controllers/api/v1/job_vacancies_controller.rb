# frozen_string_literal: true

module Api
  module V1
    class JobVacanciesController < ApiController
      def create
        job_vacancy = JobVacancy.new(params.permit(:title, :vacancy_description,
                                                   :ability_description, :level,
                                                   :region, :limit_date, :maximum_wage,
                                                   :minimum_wage, :headhunter_id))

        if job_vacancy.valid?
          if job_vacancy.save!
            render json: job_vacancy.as_json(only: [:id]), status: :created
          else
            render json: '{ "message" : "Internal server error" }', status: :internal_server_error
          end
        else
          render json: '{ "message" : "Object not create" }', status: :precondition_failed
        end
      end

      def show
        job_vacancy = JobVacancy.find(params[:id])

        render json: job_vacancy
      end

      def index
        vacancy_list = JobVacancy.where('limit_date > ?', Date.current).open

        if vacancy_list.blank?
          render json: '{ "message" : "No content" }', status: :no_content
        else
          render json: vacancy_list
        end
      end
    end
  end
end
