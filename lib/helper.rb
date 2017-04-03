Dir[File.join(__dir__, '*.rb')].each {|file| require_relative file }

class ProductNotFoundError < StandardError ; end
class EntryGroup < Struct.new(:product_code, :quantity) ; end
class EntryItem < Struct.new(:product_code, :price) ; end
