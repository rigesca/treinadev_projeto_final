class Profile
  attr_reader :tolken 
  attr_accessor :payment_methods

  def initialize(tolken)
    @tolken = tolken
    @payment_methods = []
  end

  def validate_tolken(foreing_token)
    return true if @tolken == foreing_token

    false
  end

  def include_payment_method(payment_method)
    @payment_methods << payment_method
  end
end
