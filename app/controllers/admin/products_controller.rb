class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:category).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
  end

  def new
    @product = Product.new
    @product.category_id = params[:category_id] if params[:category_id]
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    @categories = Category.all

    if @product.save
      redirect_to admin_product_path(@product), notice: 'Product was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    @categories = Category.all

    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: 'Product was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: 'Product was successfully deleted.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :size, :stock, :image_url, :category_id)
  end
end
