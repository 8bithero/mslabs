require_relative '../helper'

class Offer::ItemTrigger < Offer
  attr_reader :trigger_entries

  def initialize(opts={})
    super
    @trigger_entries = build_entries!(opts[:trigger_entries])
  end

  def valid_for?(tallied_entries)
    trigger_entries.each do |trigger_entry|
      entries = tallied_entries.select { |entry| entry.product_code == trigger_entry.product_code }
      return false unless entries.count >= trigger_entry.quantity
    end
    return true
  end
end
