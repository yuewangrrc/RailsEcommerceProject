# Create Canadian Provinces and Territories with correct tax rates
puts "Creating provinces and territories..."

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
  province = Province.find_or_create_by(name: province_data[:name]) do |p|
    p.gst_rate = province_data[:gst_rate]
    p.pst_rate = province_data[:pst_rate]
    p.hst_rate = province_data[:hst_rate]
  end
  puts "Created/Updated province: #{province.name} (Total tax: #{(province.total_tax_rate * 100).round(2)}%)"
end

puts "Provinces created successfully!"
