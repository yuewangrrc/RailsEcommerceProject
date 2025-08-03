class CartController < ApplicationController
  before_action :initialize_cart

  def show
    @cart_items = []
    
    @cart.each do |product_id, quantity|
      product = Product.find(product_id)
      @cart_items << {
        product: product,
        quantity: quantity,
        total_price: product.price * quantity
      }
    end
    
    @total_price = @cart_items.sum { |item| item[:total_price] }
  end

  def add_item
    product = Product.find(params[:product_id])
    
    if @cart[product.id.to_s]
      @cart[product.id.to_s] += 1
    else
      @cart[product.id.to_s] = 1
    end
    
    session[:cart] = @cart
    redirect_to product_path(product), notice: "#{product.name} has been added to your cart!"
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
