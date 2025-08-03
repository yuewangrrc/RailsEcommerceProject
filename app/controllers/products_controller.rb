class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  # No authentication required for browsing products
  
  def index
    @products = Product.includes(:category).where(active: true)
    @categories = Category.all
    
    # Initialize search parameters
    @search_params = {
      search: params[:search],
      category: params[:category],
      filter: params[:filter]
    }
    
    # Apply search filters
    @products = apply_search_filters(@products)
    
    # Apply special filters
    @products = apply_special_filters(@products)
    
    # Handle category navigation (different from search)
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
      @current_category = Category.find(params[:category_id])
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

  def apply_search_filters(products)
    # Keyword search in name and description
    if params[:search].present?
      search_term = params[:search].strip
      products = products.where(
        "name LIKE ? OR description LIKE ?", 
        "%#{search_term}%", "%#{search_term}%"
      )
    end
    
    # Category filter (from dropdown)
    if params[:category].present? && params[:category] != ""
      products = products.joins(:category).where(categories: { name: params[:category] })
    end
    
    products
  end

  def apply_special_filters(products)
    case params[:filter]
    when 'sale'
      products = products.on_sale
    when 'new'
      products = products.new_products
    when 'updated'
      products = products.recently_updated
    end
    
    products
  end
end
