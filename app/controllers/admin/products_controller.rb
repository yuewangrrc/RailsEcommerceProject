class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:category)
    
    # Apply search filter if present
    if params[:search].present?
      @products = @products.where("name ILIKE ? OR description ILIKE ?", 
                                  "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    # Apply category filter if present
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
    
    # Apply stock filter if present
    if params[:stock_filter].present?
      case params[:stock_filter]
      when 'in_stock'
        @products = @products.where('stock > 0')
      when 'out_of_stock'
        @products = @products.where(stock: 0)
      when 'low_stock'
        @products = @products.where('stock > 0 AND stock <= 5')
      end
    end
    
    @products = @products.order(created_at: :desc).page(params[:page]).per(20)
    @categories = Category.all
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

  def bulk_update
    if params[:bulk_action].present? && params[:product_ids].present?
      products = Product.where(id: params[:product_ids])
      
      case params[:bulk_action]
      when 'delete'
        count = products.count
        products.destroy_all
        redirect_to admin_products_path, notice: "Successfully deleted #{count} products."
      when 'mark_out_of_stock'
        products.update_all(stock: 0)
        redirect_to admin_products_path, notice: "Successfully marked #{products.count} products as out of stock."
      when 'activate'
        products.update_all(active: true)
        redirect_to admin_products_path, notice: "Successfully activated #{products.count} products."
      when 'deactivate'
        products.update_all(active: false)
        redirect_to admin_products_path, notice: "Successfully deactivated #{products.count} products."
      else
        redirect_to admin_products_path, alert: 'Invalid bulk action.'
      end
    else
      redirect_to admin_products_path, alert: 'Please select products and an action.'
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :size, :stock, :image_url, :category_id)
  end
end
