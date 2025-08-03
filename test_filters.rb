#!/usr/bin/env ruby

# Load Rails environment
require_relative 'config/environment'

puts "=== Testing Product Filters ==="
puts "Total products: #{Product.count}"

# Check current products
puts "\n=== Current Products ==="
Product.limit(5).each do |p|
  puts "#{p.name} - Created: #{p.created_at.strftime('%Y-%m-%d %H:%M')} - Updated: #{p.updated_at.strftime('%Y-%m-%d %H:%M')}"
end

# Update a product to test recently_updated filter
if Product.exists?
  product = Product.first
  puts "\n=== Updating first product for testing ==="
  puts "Before: #{product.updated_at}"
  product.update!(description: "#{product.description} - Updated for testing filters at #{Time.current}")
  puts "After: #{product.updated_at}"
end

# Set some products on sale
puts "\n=== Setting products on sale ==="
Product.limit(2).update_all(on_sale: true, sale_price: 29.99)

# Test filters
puts "\n=== Filter Results ==="
puts "New products (last 3 days): #{Product.new_products.count}"
puts "Recently updated (last 1 day): #{Product.recently_updated.count}"
puts "On sale: #{Product.on_sale.count}"

# Show details of filtered products
puts "\n=== Recently Updated Products ==="
Product.recently_updated.each do |p|
  puts "- #{p.name} (updated: #{p.updated_at.strftime('%Y-%m-%d %H:%M')})"
end

puts "\n=== Products On Sale ==="
Product.on_sale.each do |p|
  puts "- #{p.name} (sale price: $#{p.sale_price})"
end
