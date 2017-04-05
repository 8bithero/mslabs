Dir[File.join(__dir__, '*.rb')].each { |file| require_relative file }
require_relative "./offer/item_trigger.rb"
require_relative "./offer/price_trigger.rb"
require "pry"

class ProductNotFoundError < StandardError ; end
class EntryGroup < Struct.new(:product_code, :quantity) ; end
class EntryItem < Struct.new(:product_code, :price) ; end

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end
