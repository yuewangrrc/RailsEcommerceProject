class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  # No authentication required for browsing products
  
  def index
    @products = Product.includes(:category)
    @categories = Category.all
    
    # Filter by category if specified
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
      @current_category = Category.find(params[:category_id])
    end
    
    # Search functionality
    if params[:search].present?
      @products = @products.where("name ILIKE ? OR description ILIKE ?", 
                                 "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    # Filter by category from dropdown
    if params[:category].present? && params[:category] != ""  
      @products = @products.joins(:category).where(categories: { name: params[:category] })
    end
    
    @products = @products.page(params[:page]).per(12)
  end

  def show
    @related_products = Product.where(category: @product.category)
                              .where.not(id: @product.id)
                              .limit(4)
  end
  
  def search
    redirect_to products_path(search: params[:search], category: params[:category])
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
