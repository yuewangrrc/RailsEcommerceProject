class HomeController < ApplicationController
  # No authentication required for public pages
  
  def index
    @featured_products = Product.limit(6)
    @categories = Category.all
  end

  def about
    @categories = Category.all
  end
end
