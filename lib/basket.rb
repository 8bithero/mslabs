require_relative 'helper'

class Basket
  attr_reader :catalogue, :entries
  def initialize(catalogue = Catalogue.new)
    @catalogue = catalogue
    @entries = []
  end

  def add(product_code)
    product = catalogue.find_product_by_code(product_code)
    raise ProductNotFoundError, "Product not found" unless product

    entry = find_entry_by_product_code(product_code)
    return update_entry_quantity(entry) if entry
    new_entry(product_code)
  end

  def total
    total = sub_total + delivery_charge
    total.to_f / 100
  end

  def sub_total
    calculate_sub_total
  end

  def delivery_charge
    DeliveryCharge.for_amount(sub_total)
  end

  private

    def calculate_sub_total
      tallied_entries = tally_entries(@entries)
      return 0 if tallied_entries.empty?
      catalogue.offers.each do |offer|
        tallied_entries = offer.apply(tallied_entries) if offer.valid_for?(tallied_entries)
      end
      price_before_delivery = tallied_entries.map(&:price).reduce(:+)
    end

    def update_entry_quantity(entry)
      entry.quantity += 1
      entry
    end

    def find_entry_by_product_code(product_code)
      @entries.find { |entry| entry.product_code == product_code.to_s.upcase }
    end

    def new_entry(product_code)
      entry = EntryGroup.new(product_code, 1)
      @entries << entry
      entry
    end

    def tally_entries(entries)
      entries.reduce([]) do |tallied_items, entry|
        product = catalogue.find_product_by_code(entry.product_code)
        entry.quantity.times { tallied_items << EntryItem.new(product.code, product.price) }
        tallied_items
      end
    end
end
