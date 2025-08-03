# This file shoul🧹 Clearing existing data...
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all
Province.destroy_all

# Data Source 0: Create Canadian Provinces and Territories with tax rates
puts "\n🍁 Creating Canadian provinces and territories..."

provinces_data = [
  # Provinces with HST
  { name: "New Brunswick", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Newfoundland and Labrador", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Nova Scotia", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Ontario", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.13 },
  { name: "Prince Edward Island", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  
  # Provinces with GST + PST
  { name: "Alberta", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 },
  { name: "British Columbia", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.0 },
  { name: "Manitoba", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.0 },
  { name: "Quebec", gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0.0 },
  { name: "Saskatchewan", gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.0 },
  
  # Territories with GST only
  { name: "Northwest Territories", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 },
  { name: "Nunavut", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 },
  { name: "Yukon", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 }
]

provinces_data.each do |province_data|
  province = Province.create!(
    name: province_data[:name],
    gst_rate: province_data[:gst_rate],
    pst_rate: province_data[:pst_rate],
    hst_rate: province_data[:hst_rate]
  )
  puts "🍁 Created #{province.name} (Total tax: #{(province.total_tax_rate * 100).round(2)}%)"
end

# This file should contain all the record creation needed to ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'faker'
require_relative '../lib/swimwear_scraper'
require_relative '../lib/swimwear_api_extractor'
require_relative '../lib/csv_data_extractor'

# Initialize data extractors
puts "🚀 Starting seed process with multiple data sources..."
puts "📊 Data Sources: CSV Files, External API, Web Scraping, Faker"

scraper = SwimwearScraper.new
api_extractor = SwimwearApiExtractor.new

# Clear existing data
puts "\n🧹 Clearing existing data..."
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

# Data Source 1: Categories from CSV file
puts "\n📄 Creating categories from CSV data..."
csv_categories = CsvDataExtractor.load_categories
CsvDataExtractor.validate_csv_data(csv_categories, 'categories')

categories = []
csv_categories.each do |cat_data|
  category = Category.create!(
    name: cat_data[:name],
    description: cat_data[:description]
  )
  categories << category
  puts "✅ Created category: #{category.name} (source: #{cat_data[:data_source]})"
end

# Data Source 2: Additional categories from API
puts "\n📡 Adding categories from API..."
api_categories = api_extractor.fetch_categories
api_categories['data'].each do |api_cat|
  # Only add if not already exists
  unless categories.any? { |cat| cat.name.downcase.include?(api_cat['name'].downcase.split.first) }
    category = Category.create!(
      name: api_cat['name'],
      description: api_cat['description']
    )
    categories << category
    puts "✅ Created category: #{category.name} (source: API)"
  end
end

# Data Source 2: Users (Generated with Faker)
puts "
👥 Creating users with Faker..."
users = []
provinces = Province.all

10.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password',
    province: provinces.sample
  )
  users << user
  puts "👤 Created user: #{user.name} (#{user.email}) - #{user.province.name}"
end

# Data Source 3: Products from CSV file
puts "\n📄 Creating products from CSV data..."
csv_products = CsvDataExtractor.load_products
CsvDataExtractor.validate_csv_data(csv_products, 'products')

products = []
csv_products.each do |product_data|
  category = categories.find { |cat| cat.name == product_data[:category] }
  next unless category
  
  product_data[:sizes].each do |size|
    product = Product.create!(
      name: product_data[:name],
      price: product_data[:price],
      description: "#{product_data[:description]} Made from #{product_data[:material]} by #{product_data[:brand]}.",
      size: size,
      stock: rand(10..75),
      active: true,
      category: category
    )
    products << product
    puts "📄 Created #{product.name} (Size: #{size}) - $#{product.price} [CSV Data]"
  end
end

# Data Source 4: Products from API
puts "\n📡 Creating products from API data..."
api_products = api_extractor.fetch_products
inventory_data = api_extractor.fetch_inventory_data

api_products['data'].each do |api_product|
  # Find matching category or use first one
  category = categories.find { |cat| cat.id == api_product['category_id'] } || categories.first
  
  api_product['sizes_available'].each do |size|
    # Get inventory info
    inventory = inventory_data['data'][api_product['id'].to_s] || {}
    stock_level = inventory['stock_level'] || rand(15..60)
    
    product = Product.create!(
      name: api_product['name'],
      price: api_product['sale_price'] || api_product['price'],
      description: "#{api_product['description']} Features: #{api_product['features'].join(', ')}. Material: #{api_product['material']}.",
      size: size,
      stock: stock_level,
      active: true,
      on_sale: api_product['sale_price'].present?,
      sale_price: api_product['sale_price'],
      category: category
    )
    products << product
    puts "📡 Created #{product.name} (Size: #{size}) - $#{product.price} [API Data]"
  end
end

# Data Source 5: Additional products from web scraping
puts "\n🕷️  Adding products from web scraping..."
scraped_products = scraper.scrape_products

scraped_products.each do |product_data|
  category = categories.find { |cat| cat.name == product_data[:category] }
  next unless category
  
  # Only add a few sizes to avoid duplication
  product_data[:sizes].first(2).each do |size|
    min_price, max_price = product_data[:price_range]
    price = rand(min_price..max_price).round(2)
    
    product = Product.create!(
      name: product_data[:name],
      price: price,
      description: "#{product_data[:description]} #{Faker::Lorem.sentence}",
      size: size,
      stock: rand(5..40),
      active: true,
      category: category
    )
    products << product
    puts "🌐 Created #{product.name} (Size: #{size}) - $#{product.price} [Scraped Data]"
  end
end

puts "\n📊 Products summary by data source:"
puts "  - CSV file: #{csv_products.sum { |p| p[:sizes].count }} variants"
puts "  - API: #{api_products['data'].sum { |p| p['sizes_available'].count }} variants"  
puts "  - Web scraping: #{scraped_products.sum { |p| p[:sizes].first(2).count }} variants"
puts "  - Total products created: #{products.count}"

# Data Source 5: Sample Orders (Faker generated with relationships)
puts "\n📦 Creating sample orders..."
5.times do |i|
  user = users.sample
  province = provinces.sample
  
  # Add random order items first, then calculate total
  num_items = rand(1..4)
  subtotal = 0
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
    
    subtotal += item_price * quantity
  end
  
  # Calculate tax and total
  tax = (subtotal * province.total_tax_rate).round(2)
  total = subtotal + tax
  
  # Create order with calculated total
  order = Order.create!(
    user: user,
    province: province,
    subtotal: subtotal,
    tax: tax,
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
  
  puts "📦 Created order for #{user.name} - Subtotal: $#{subtotal.round(2)}, Tax: $#{tax}, Total: $#{total.round(2)} (#{province.name})"
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
