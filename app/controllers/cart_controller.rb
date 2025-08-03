class CartController < ApplicationController
  before_action :initialize_cart

  def show
    @cart_items = []
    invalid_items = []
    
    @cart.each do |product_id, quantity|
      begin
        product = Product.find(product_id)
        @cart_items << {
          product: product,
          quantity: quantity,
          total_price: product.price * quantity
        }
      rescue ActiveRecord::RecordNotFound
        # Product no longer exists, mark for removal from cart
        invalid_items << product_id
      end
    end
    
    # Remove invalid items from cart
    if invalid_items.any?
      invalid_items.each { |id| @cart.delete(id) }
      session[:cart] = @cart
      flash[:warning] = "Some items in your cart are no longer available and have been removed."
    end
    
    @total_price = @cart_items.sum { |item| item[:total_price] }
  end

  def add_item
    begin
      product = Product.find(params[:product_id])
      
      if @cart[product.id.to_s]
        @cart[product.id.to_s] += 1
      else
        @cart[product.id.to_s] = 1
      end
      
      session[:cart] = @cart
      redirect_to product_path(product), notice: "#{product.name} has been added to your cart!"
    rescue ActiveRecord::RecordNotFound
      redirect_to products_path, alert: "Product not found."
    end
  end

  def update_item
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
    
    if quantity > 0
      @cart[product_id] = quantity
    else
      @cart.delete(product_id)
    end
    
    session[:cart] = @cart
    redirect_to cart_path, notice: 'Cart updated successfully!'
  end

  def remove_item
    @cart.delete(params[:product_id])
    session[:cart] = @cart
    redirect_to cart_path, notice: 'Item removed from cart!'
  end

  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: 'Cart cleared!'
  end

  private

  def initialize_cart
    @cart = session[:cart] ||= {}
  end
end
