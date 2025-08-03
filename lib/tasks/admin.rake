namespace :admin do
  desc "Create admin user"
  task create_user: :environment do
    puts "Creating admin user..."
    
    admin = User.find_or_create_by(email: 'admin@swimi.com') do |user|
      user.name = 'Admin'
      user.password = 'admin123'
      user.password_confirmation = 'admin123'
      user.admin = true
    end
    
    if admin.persisted?
      # Ensure admin flag is set
      admin.update!(admin: true) unless admin.admin?
      
      puts "✅ Admin user created/updated successfully!"
      puts "📧 Email: admin@swimi.com"
      puts "🔑 Password: admin123"
      puts "👑 Admin status: #{admin.admin?}"
      puts ""
      puts "You can now log in to the admin panel at: http://localhost:3000/admin"
    else
      puts "❌ Error creating admin user:"
      admin.errors.full_messages.each { |msg| puts "   - #{msg}" }
    end
  end
end
