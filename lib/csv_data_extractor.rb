require 'csv'

class CsvDataExtractor
  
  def self.load_categories
    puts "📄 Loading categories from CSV file..."
    categories = []
    
    csv_path = Rails.root.join('db', 'data', 'categories.csv')
    
    unless File.exist?(csv_path)
      puts "❌ Categories CSV file not found at #{csv_path}"
      return []
    end

    CSV.foreach(csv_path, headers: true) do |row|
      categories << {
        name: row['name'],
        description: row['description'],
        active: row['active'] == 'true',
        display_order: row['display_order'].to_i,
        data_source: 'CSV'
      }
    end
    
    puts "✅ Loaded #{categories.count} categories from CSV"
    categories
  end

  def self.load_products
    puts "📄 Loading products from CSV file..."
    products = []
    
    csv_path = Rails.root.join('db', 'data', 'products.csv')
    
    unless File.exist?(csv_path)
      puts "❌ Products CSV file not found at #{csv_path}"
      return []
    end

    CSV.foreach(csv_path, headers: true) do |row|
      # Parse sizes from comma-separated string
      sizes = row['sizes'].split(',').map(&:strip)
      
      products << {
        name: row['name'],
        category: row['category'],
        description: row['description'],
        price: row['price'].to_f,
        sizes: sizes,
        material: row['material'],
        brand: row['brand'],
        data_source: 'CSV'
      }
    end
    
    puts "✅ Loaded #{products.count} products from CSV"
    products
  end

  def self.validate_csv_data(data, type)
    puts "🔍 Validating #{type} CSV data..."
    
    case type
    when 'categories'
      required_fields = ['name', 'description']
      data.each_with_index do |item, index|
        required_fields.each do |field|
          if item[field.to_sym].blank?
            puts "⚠️  Warning: #{type.capitalize} at row #{index + 1} missing #{field}"
          end
        end
      end
    when 'products'
      required_fields = ['name', 'category', 'price']
      data.each_with_index do |item, index|
        required_fields.each do |field|
          if item[field.to_sym].blank?
            puts "⚠️  Warning: #{type.capitalize} at row #{index + 1} missing #{field}"
          end
        end
        
        # Validate price
        if item[:price] <= 0
          puts "⚠️  Warning: Product at row #{index + 1} has invalid price: #{item[:price]}"
        end
      end
    end
    
    puts "✅ CSV data validation completed"
  end

  def self.export_to_csv(data, filename)
    puts "💾 Exporting data to CSV: #{filename}"
    
    csv_path = Rails.root.join('tmp', filename)
    
    CSV.open(csv_path, 'w', write_headers: true, headers: data.first.keys) do |csv|
      data.each do |row|
        csv << row.values
      end
    end
    
    puts "✅ Data exported to #{csv_path}"
    csv_path
  end
end
