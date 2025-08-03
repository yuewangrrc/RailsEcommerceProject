# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'faker'

# Clear existing data
puts "Clearing existing data..."
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

# Data Source 1: Categories (Manual data)
puts "Creating categories..."
categories_data = [
  { name: "Women's Swimwear" },
  { name: "Men's Swimwear" },
  { name: "Kids' Swimwear" },
  { name: "Swimwear Accessories" }
]

categories = []
categories_data.each do |cat_data|
  category = Category.create!(cat_data)
  categories << category
  puts "Created category: #{category.name}"
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

# Data Source 3: Products (Mixed Faker and manual data)
puts "Creating products..."
swimwear_products = [
  # Women's Swimwear
  { name: "Classic One-Piece Swimsuit", category: "Women's Swimwear", sizes: ["S", "M", "L", "XL"] },
  { name: "Bikini Set - Tropical Print", category: "Women's Swimwear", sizes: ["XS", "S", "M", "L"] },
  { name: "High-Waisted Bikini Bottom", category: "Women's Swimwear", sizes: ["S", "M", "L", "XL"] },
  { name: "Sports Swimsuit", category: "Women's Swimwear", sizes: ["S", "M", "L", "XL", "XXL"] },
  { name: "Tankini Set", category: "Women's Swimwear", sizes: ["M", "L", "XL", "XXL"] },
  
  # Men's Swimwear
  { name: "Board Shorts - Classic", category: "Men's Swimwear", sizes: ["S", "M", "L", "XL", "XXL"] },
  { name: "Swim Trunks - Quick Dry", category: "Men's Swimwear", sizes: ["S", "M", "L", "XL"] },
  { name: "Compression Swim Shorts", category: "Men's Swimwear", sizes: ["S", "M", "L", "XL"] },
  { name: "Swim Briefs - Competition", category: "Men's Swimwear", sizes: ["S", "M", "L", "XL"] },
  
  # Kids' Swimwear
  { name: "Kids One-Piece - Unicorn", category: "Kids' Swimwear", sizes: ["2T", "3T", "4T", "5T", "6"] },
  { name: "Boys Swim Shorts - Shark Print", category: "Kids' Swimwear", sizes: ["2T", "3T", "4T", "5T", "6", "7", "8"] },
  { name: "Girls Bikini Set - Rainbow", category: "Kids' Swimwear", sizes: ["3T", "4T", "5T", "6", "7", "8"] },
  { name: "Rash Guard Set - Ocean Theme", category: "Kids' Swimwear", sizes: ["2T", "3T", "4T", "5T", "6", "7"] },
  
  # Accessories
  { name: "Swim Goggles - Professional", category: "Swimwear Accessories", sizes: ["One Size"] },
  { name: "Beach Towel - Microfiber", category: "Swimwear Accessories", sizes: ["Large"] },
  { name: "Swim Cap - Silicone", category: "Swimwear Accessories", sizes: ["One Size"] },
  { name: "Waterproof Phone Case", category: "Swimwear Accessories", sizes: ["Universal"] }
]

products = []
swimwear_products.each do |product_data|
  category = categories.find { |cat| cat.name == product_data[:category] }
  
  product_data[:sizes].each do |size|
    price = rand(15.99..199.99).round(2)
    stock = rand(5..50)
    
    product = Product.create!(
      name: product_data[:name],
      price: price,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      size: size,
      stock: stock,
      image_url: "https://via.placeholder.com/300x400/#{%w[FF6B6B 4ECDC4 45B7D1 96CEB4 FFEAA7 DDA0DD].sample}/FFFFFF?text=#{product_data[:name].gsub(' ', '+')}",
      category: category
    )
    products << product
    puts "Created #{product.name} (Size: #{size}) - $#{product.price}"
  end
end

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
=== SEEDING COMPLETED ==="
puts "Categories: #{Category.count}"
puts "Users: #{User.count}"
puts "Products: #{Product.count}"
puts "Orders: #{Order.count}"
puts "Order Items: #{OrderItem.count}"
puts "Total records: #{Category.count + User.count + Product.count + Order.count + OrderItem.count}"
