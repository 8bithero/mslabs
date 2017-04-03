class DeliveryCharge
  def self.for_amount(amount)
    case
    when amount < 5000
      495
    when amount < 9000
      295
    else
      0
    end
  end
end
