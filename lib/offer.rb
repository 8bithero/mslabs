require_relative 'helper'

class Offer
  attr_reader :trigger_entries, :affected_entries, :new_unit_price, :discount_percentage

  def initialize(opts={})
    @trigger_entries = build_entries!(opts[:trigger_entries])
    @affected_entries = build_entries!(opts[:affected_entries])
    @new_unit_price = opts[:new_unit_price]
    @discount_percentage = opts[:discount_percentage]
  end

  def valid_for?(tallied_entries)
    trigger_entries.each do |trigger_entry|
      entries = tallied_entries.select { |entry| entry.product_code == trigger_entry.product_code }
      return false unless entries.count >= trigger_entry.quantity
    end
    return true
  end

  def apply(tallied_entries)
    affected_entries.each do |affected_entry|
      entries = tallied_entries.select { |tally_entry| tally_entry.product_code == affected_entry.product_code }
      entries.first(affected_entry.quantity).each do |entry|
        entry.price = new_unit_price ? new_unit_price : (entry.price * discount_percentage)/100
      end
    end
    tallied_entries
  end

  private
    def build_entries!(trigger_entries)
      trigger_entries.reduce([]) do |entries, entry|
        entries << EntryGroup.new(entry.keys.first.to_s, entry.values.first)
      end
    end
end
