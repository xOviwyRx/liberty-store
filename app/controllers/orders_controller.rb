class OrdersController < ApplicationController
  allow_unauthenticated_access

  def show
    @order = Order.find_by_token_for(:show, params[:token])
    return redirect_to root_path, alert: "Order not found." unless @order

    @order_items = @order.order_items.includes(:product)
  end
end
