module Api
    module V1
        class ApiController < ActionController::API
            rescue_from ActiveRecord::RecordNotFound, with: :object_not_found 

            def object_not_found
                render json: '{ "message" : "Object not found"}', status: 412
            end
        end
    end
end