# Swimi - Rails E-commerce Project

A modern e-commerce web application built with Ruby on Rails, featuring a complete online store for swimwear with admin management, shopping cart functionality, and advanced search capabilities.

## 🚀 Features

- **Admin Dashboard**: Complete product and category management
- **Product Catalog**: Browse products by category with pagination
- **Advanced Search**: Keyword and category-based product filtering
- **Shopping Cart**: Session-based cart with quantity management
- **Checkout Process**: Complete order flow with Canadian tax calculations
- **User Authentication**: Secure login/registration with Devise
- **Responsive Design**: Mobile-friendly interface with Bootstrap

## 🛠 Tech Stack

- **Ruby**: 3.3.8
- **Rails**: 8.0.2
- **Database**: SQLite3 (Development)
- **Authentication**: Devise
- **Frontend**: Bootstrap 5.2.3, ERB Templates
- **Pagination**: Kaminari
- **Testing**: Rails default test suite

## 📁 Project Structure

```
RailsEcommerceProject/
├── app/
│   ├── controllers/
│   │   ├── admin/                 # Admin namespace controllers
│   │   │   ├── base_controller.rb # Admin authentication base
│   │   │   ├── dashboard_controller.rb
│   │   │   ├── products_controller.rb
│   │   │   └── categories_controller.rb
│   │   ├── application_controller.rb
│   │   ├── cart_controller.rb     # Shopping cart management
│   │   ├── categories_controller.rb
│   │   ├── checkout_controller.rb # Order processing
│   │   ├── home_controller.rb
│   │   └── products_controller.rb # Product display & search
│   ├── models/
│   │   ├── category.rb           # Product categories
│   │   ├── order.rb              # Customer orders
│   │   ├── order_item.rb         # Order line items
│   │   ├── product.rb            # Products with validations
│   │   ├── province.rb           # Canadian tax calculations
│   │   └── user.rb               # User authentication
│   ├── views/
│   │   ├── admin/                # Admin interface views
│   │   ├── layouts/
│   │   │   ├── application.html.erb # Main layout
│   │   │   └── admin.html.erb    # Admin layout
│   │   ├── shared/               # Reusable view partials
│   │   │   ├── _breadcrumbs.html.erb
│   │   │   ├── _flash_messages.html.erb
│   │   │   └── _product_card.html.erb
│   │   ├── cart/                 # Shopping cart views
│   │   ├── categories/           # Category listing & details
│   │   ├── checkout/             # Checkout process
│   │   ├── home/                 # Homepage & about
│   │   └── products/             # Product catalog
│   └── assets/                   # CSS, JS, and images
├── config/
│   ├── routes.rb                 # Application routing
│   ├── database.yml              # Database configuration
│   └── initializers/             # Rails initializers
├── db/
│   ├── migrate/                  # Database migrations
│   ├── seeds.rb                  # Sample data seeding
│   └── schema.rb                 # Current database schema
└── Gemfile                       # Ruby dependencies
```

## 🗃 Database Schema

### Core Tables
- **users**: Customer and admin accounts with Devise authentication
- **categories**: Product categorization (Women's, Men's, Kids, etc.)
- **products**: Product catalog with pricing, stock, and descriptions
- **provinces**: Canadian provinces with GST/PST/HST tax rates
- **orders**: Customer order records
- **order_items**: Individual items within orders

### Key Relationships
- Products belong to Categories (many-to-one)
- Users can have many Orders
- Orders contain many Order Items
- Users belong to Provinces (for tax calculation)

## 🎯 Key Features Implementation

### Admin Management
- Secure admin authentication with role-based access
- CRUD operations for products and categories
- Dashboard with statistics and quick actions

### Shopping Experience
- Product browsing with category filtering
- Advanced search with keyword and category filters
- Session-based shopping cart (no login required)
- Complete checkout with tax calculation

### Tax System
- Full Canadian provincial tax support
- Automatic GST/PST/HST calculation based on user province
- Accurate tax rates for all 13 provinces and territories

### User Interface
- Responsive Bootstrap design
- Breadcrumb navigation
- Flash message system
- Product card components for consistent display

## 🚦 Installation & Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/RailsEcommerceProject.git
cd RailsEcommerceProject

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Start the server
rails server
```

## 🔐 Admin Access

Access the admin dashboard at `/admin` with administrator credentials.
Default admin user can be created through the Rails console or seeded data.

## 📊 Project Status

Current implementation includes all core e-commerce functionality:
- ✅ Product management and display
- ✅ Shopping cart and checkout
- ✅ User authentication
- ✅ Search and filtering
- ✅ Admin dashboard
- ✅ Canadian tax system
- ✅ Responsive design

## 🤝 Contributing

This project follows standard Rails conventions and best practices. 
Contributions are welcome through pull requests with proper testing.
