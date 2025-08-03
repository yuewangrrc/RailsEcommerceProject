class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_cart
  before_action :ensure_cart_not_empty

  def show
    @provinces = Province.all.order(:name)
    
    # Calculate cart totals
    @cart_items = build_cart_items
    @subtotal = @cart_items.sum { |item| item[:total_price] }
    
    # Get user's province for tax calculation
    if current_user.province
      @province = current_user.province
      @tax_amount = (@subtotal * @province.total_tax_rate).round(2)
      @total = @subtotal + @tax_amount
    else
      @province = nil
      @tax_amount = 0
      @total = @subtotal
    end
  end

  def create_order
    @provinces = Province.all.order(:name)
    
    # Update user address if provided
    if params[:user].present?
      unless current_user.update(user_params)
        flash[:alert] = "Please fix the address errors."
        redirect_to checkout_path and return
      end
    end

    # Ensure user has address
    unless current_user.has_address?
      flash[:alert] = "Please provide your address to continue."
      redirect_to checkout_path and return
    end

    # Build cart items and calculate totals
    @cart_items = build_cart_items
    @subtotal = @cart_items.sum { |item| item[:total_price] }
    @tax_amount = (@subtotal * current_user.province.total_tax_rate).round(2)
    @total = @subtotal + @tax_amount

    # Create order
    @order = current_user.orders.build(
      total_price: @total,
      subtotal: @subtotal,
      tax: @tax_amount,
      status: 'pending',
      province: current_user.province,
      shipping_name: current_user.name,
      shipping_address: current_user.street_address,
      shipping_city: current_user.city,
      shipping_postal_code: current_user.postal_code
    )

    if @order.save
      # Create order items
      @cart_items.each do |item|
        @order.order_items.create!(
          product: item[:product],
          quantity: item[:quantity],
          price: item[:product].price
        )
      end

      # Clear cart
      session[:cart] = {}
      
      redirect_to order_confirmation_path(@order), notice: 'Order placed successfully!'
    else
      flash[:alert] = "There was an error processing your order."
      render :show
    end
  end

  def order_confirmation
    @order = current_user.orders.find(params[:id])
    @order_items = @order.order_items.includes(:product)
  end

  private

  def initialize_cart
    @cart = session[:cart] ||= {}
  end

  def ensure_cart_not_empty
    if @cart.empty?
      redirect_to products_path, alert: 'Your cart is empty.'
    end
  end

  def build_cart_items
    cart_items = []
    @cart.each do |product_id, quantity|
      product = Product.find(product_id)
      cart_items << {
        product: product,
        quantity: quantity,
        total_price: product.price * quantity
      }
    end
    cart_items
  end

  def user_params
    params.require(:user).permit(:street_address, :city, :postal_code, :province_id)
  end
end
