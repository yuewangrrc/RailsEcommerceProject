namespace :scraper do
  desc "Run web scraper to fetch latest swimwear data"
  task fetch_data: :environment do
    puts "🕷️  Starting web scraper..."
    
    scraper = SwimwearScraper.new
    
    puts "📦 Fetching categories..."
    categories = scraper.scrape_categories
    puts "   Found #{categories.count} categories"
    
    puts "🏊 Fetching products..."
    products = scraper.scrape_products  
    puts "   Found #{products.count} unique products"
    
    # Save scraped data to JSON for review
    scraped_data = {
      scraped_at: Time.current,
      categories: categories,
      products: products
    }
    
    File.open('tmp/scraped_data.json', 'w') do |file|
      file.write(JSON.pretty_generate(scraped_data))
    end
    
    puts "💾 Scraped data saved to tmp/scraped_data.json"
    puts "✅ Scraping completed successfully!"
  end
  
  desc "Import scraped data to database"
  task import: :environment do
    puts "📥 Importing scraped data to database..."
    
    unless File.exist?('tmp/scraped_data.json')
      puts "❌ No scraped data found. Run 'rake scraper:fetch_data' first."
      exit
    end
    
    data = JSON.parse(File.read('tmp/scraped_data.json'), symbolize_names: true)
    
    # Import categories
    data[:categories].each do |cat_data|
      category = Category.find_or_create_by(name: cat_data[:name]) do |cat|
        cat.description = cat_data[:description]
      end
      puts "📁 Category: #{category.name}"
    end
    
    # Import products
    imported_count = 0
    data[:products].each do |prod_data|
      category = Category.find_by(name: prod_data[:category])
      next unless category
      
      prod_data[:sizes].each do |size|
        existing = Product.find_by(name: prod_data[:name], size: size)
        unless existing
          min_price, max_price = prod_data[:price_range]
          Product.create!(
            name: prod_data[:name],
            category: category,
            description: prod_data[:description],
            size: size,
            price: rand(min_price..max_price).round(2),
            stock: rand(10..100),
            active: true
          )
          imported_count += 1
        end
      end
    end
    
    puts "✅ Import completed! Added #{imported_count} new products."
  end
  
  desc "Full scrape and import process"
  task full_update: :environment do
    Rake::Task['scraper:fetch_data'].invoke
    Rake::Task['scraper:import'].invoke
    puts "🎉 Full scraper update completed!"
  end
end
