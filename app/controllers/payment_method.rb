class PaymentMethod

    attr_accessor :name, :tax, :discount, :installments

    def initialize(name, tax, discount, installments)
      @name = name
      @tax = tax
      @discount = discount
      @installments = installments
    end

    def calculate_discont(value)
      value - (value * discount)
    end

    def calculate_tax(value)
      value + (value * tax)
    end
end