class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.orders.includes(:order_items => :product)
                         .order(created_at: :desc)
                         .page(params[:page]).per(10)
  end

  def show
    # Order is set by before_action
    redirect_to orders_path, alert: "Order not found." unless @order
  end

  private

  def set_order
    @order = current_user.orders.find_by(id: params[:id])
  end
end
