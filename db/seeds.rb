# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'faker'
require_relative '../lib/swimwear_scraper'

# Initialize the scraper
puts "🚀 Starting seed process with web scraped data..."
scraper = SwimwearScraper.new

# Clear existing data
puts "Clearing existing data..."
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

# Data Source 1: Categories (Scraped from external website)
puts "Creating categories from scraped data..."
scraped_categories = scraper.scrape_categories

categories = []
scraped_categories.each do |cat_data|
  category = Category.create!(
    name: cat_data[:name],
    description: cat_data[:description]
  )
  categories << category
  puts "✅ Created category: #{category.name} (source: #{cat_data[:source]})"
end

# Data Source 2: Users (Faker generated)
puts "Creating users with Faker..."
users = []
10.times do |i|
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password123",
    password_confirmation: "password123"
  )
  users << user
  puts "Created user: #{user.name} (#{user.email})"
end

# Data Source 3: Products (Scraped from external website with Faker enhancements)
puts "Creating products from scraped data..."
scraped_products = scraper.scrape_products

products = []
scraped_products.each do |product_data|
  category = categories.find { |cat| cat.name == product_data[:category] }
  
  product_data[:sizes].each do |size|
    # Use scraped price range with some randomization
    min_price, max_price = product_data[:price_range]
    price = rand(min_price..max_price).round(2)
    stock = rand(5..50)
    
    # Enhance scraped description with Faker if needed
    enhanced_description = "#{product_data[:description]} #{Faker::Lorem.sentence}"
    
    product = Product.create!(
      name: product_data[:name],
      price: price,
      description: enhanced_description,
      size: size,
      stock: stock,
      active: true,
      category: category
    )
    products << product
    puts "🌐 Created #{product.name} (Size: #{size}) - $#{product.price} [Scraped from: #{product_data[:source_url]}]"
  end
end

puts "📊 Scraped products summary:"
puts "  - Total unique products: #{scraped_products.count}"
puts "  - Total product variants: #{products.count}"
puts "  - Source: External swimwear websites"

# Data Source 4: Sample Orders (Faker generated with relationships)
puts "Creating sample orders..."
5.times do |i|
  user = users.sample
  
  # Add random order items first, then calculate total
  num_items = rand(1..4)
  total = 0
  order_items_data = []
  
  num_items.times do
    product = products.sample
    quantity = rand(1..3)
    item_price = product.price
    
    order_items_data << {
      product: product,
      quantity: quantity,
      price: item_price
    }
    
    total += item_price * quantity
  end
  
  # Create order with calculated total
  order = Order.create!(
    user: user,
    total_price: total,
    status: %w[pending processing shipped delivered].sample
  )
  
  # Create order items
  order_items_data.each do |item_data|
    OrderItem.create!(
      order: order,
      product: item_data[:product],
      quantity: item_data[:quantity],
      price: item_data[:price]
    )
  end
  
  puts "Created order for #{user.name} - Total: $#{total.round(2)}"
end

puts "
=== SEEDING COMPLETED WITH WEB SCRAPED DATA ==="
puts "🌐 Data Sources Used:"
puts "  1. Categories: Scraped from external swimwear websites"
puts "  2. Products: Scraped from external swimwear websites"  
puts "  3. Users: Generated with Faker"
puts "  4. Orders: Generated with Faker + scraped products"
puts ""
puts "📈 Final Statistics:"
puts "Categories: #{Category.count}"
puts "Users: #{User.count}"
puts "Products: #{Product.count}"
puts "Orders: #{Order.count}"
puts "Order Items: #{OrderItem.count}"
puts "Total records: #{Category.count + User.count + Product.count + Order.count + OrderItem.count}"
puts ""
puts "✅ All data successfully scraped and imported!"
