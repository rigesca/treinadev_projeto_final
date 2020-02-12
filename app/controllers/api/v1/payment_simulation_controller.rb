module Api
  module V1
    class PaymentSimulationController < ApiController
      
      def simulation
        profile = Profile.new('15ad851a1')

        if profile.validate_tolken(params[:tolken])
          boleto = PaymentMethod.new('boleto', 0.1, 0.1, 1)
          credit = PaymentMethod.new('cartão de credito', 0.5, 0.5, 12)
          
          profile.include_payment_method(boleto)
          profile.include_payment_method(credit)

          json = []

          byebug 
          profile.payment_methods.each do |x|
            linha = '{'
            linha.insert("payment_method : #{x.name},")
            linha.insert("value : #{1000},")
            linha.insert("discount  : #{x.calculate_discont(1000)},")
            linha.insert("tax_total  : #{x.calculate_tax(1000)},")
            linha.insert("installments  : #{x.installments},")
            linha.insert('}')
            json << linha
          end
byebug
          render json: json, status: :ok
        else
          render json: '{ "message" : "invalid token" }', status: :precondition_failed
        end
      end
    end
  end
end
