class CandidateListController < ApplicationController

    def index
        byebug
        @job = JobVacancy.find(params[:id])
        
    end

end