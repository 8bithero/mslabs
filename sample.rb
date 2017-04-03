#!/usr/bin/env ruby
require_relative 'lib/basket.rb'

ORDERS = [
  %w(S01 B01),
  %w(J01 J01),
  %w(J01 B01),
  %w(S01 S01 J01 J01 J01)
]

puts "---------------------------------------------"
puts "Building orders..."
puts "---------------------------------------------"
ORDERS.each_with_index do |order_products, index|
  basket = Basket.new
  puts "ORDER ##{index+1}"
  order_products.each { |product_code| basket.add(product_code) }
  puts "Added products: #{order_products.join(', ')}"
  puts "Sub-total: £#{(basket.sub_total.to_f)/100}"
  puts "Delivery: £#{(basket.delivery_charge.to_f)/100}"
  puts "Total: £#{basket.total}"
  puts "-----------------"
end
