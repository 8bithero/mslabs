require_relative '../helper'

class Offer::PriceTrigger < Offer
  attr_reader :trigger_price

  def initialize(opts={})
    @trigger_price = opts[:trigger_price]
    super
  end

  def valid_for?(tallied_entries)
    tallied_entries.map(&:price).reduce(:+) >= @trigger_price
  end
end
