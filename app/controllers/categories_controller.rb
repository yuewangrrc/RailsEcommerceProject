class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  # No authentication required for browsing categories
  
  def index
    @categories = Category.all
  end

  def show
    @products = @category.products.page(params[:page]).per(12)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
