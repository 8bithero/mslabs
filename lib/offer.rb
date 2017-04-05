require_relative 'helper'

class Offer
  attr_reader :type, :affected_entries, :new_unit_price, :discount_percentage

  def initialize(opts={})
    @type = opts[:type]
    @affected_entries = build_entries!(opts[:affected_entries])
    @new_unit_price = opts[:new_unit_price]
    @discount_percentage = opts[:discount_percentage]
    @catalogue = opts[:catalogue]
  end

  def valid_for?(tallied_entries)
    raise "Not implemented!"
  end

  def apply(tallied_entries, basket)
    affected_entries = basket.entries if affected_entries.blank?
    affected_entries.each do |affected_entry|
      entries = tallied_entries.select do |tally_entry|
        tally_entry.product_code == affected_entry.product_code
      end

      entries.first(affected_entry.quantity).each do |entry|
        entry.price = new_unit_price ? new_unit_price : (entry.price * discount_percentage)/100
      end
    end
    tallied_entries
  end

  private
    def build_entries!(trigger_entries)
      return if trigger_entries.blank?
      trigger_entries.map { |entry| EntryGroup.new(entry.keys.first.to_s, entry.values.first) }
    end
end
