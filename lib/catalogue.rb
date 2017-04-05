require_relative 'helper'

class Catalogue
  PRODUCTS = [
    { name: "Jeans",  code: "J01", price: 3295 },
    { name: "Blouse", code: "B01", price: 2495 },
    { name: "Socks",  code: "S01", price: 795 }
  ]

  OFFERS = [
    # {
    #   "type": "item_trigger",
    #   "trigger_entries":  [ {"J01": 2} ],
    #   "affected_entries": [ {"J01": 1} ],
    #   "new_unit_price": nil,
    #   "discount_percentage": 50
    # },
    {
      "type": "price_trigger",
      "trigger_price":  6000,
      "affected_entries": nil,
      "new_unit_price": nil,
      "discount_percentage": 10
    },
  ]

  attr_reader :products, :offers

  def initialize(products=PRODUCTS, offers=OFFERS)
    @products = build_products!(products)
    @offers = build_offers!(offers)
  end

  def find_product_by_code(product_code)
    @products.find{ |product| product.code == product_code.to_s.upcase }
  end

  private
    def build_products!(products)
      products.map{ |params| Product.new(params) }
    end

    def build_offers!(offers)
      offers.map do |params|
        case params[:type]
        when "item_trigger"
          Offer::ItemTrigger.new(params.merge(catalogue: self))
        when "price_trigger"
          Offer::PriceTrigger.new(params.merge(catalogue: self))
        end
      end
    end
end
