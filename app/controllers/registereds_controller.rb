class RegisteredsController < ApplicationController

    def index
        @registereds = Registered.where(candidate_id: current_candidate)
    end

end
