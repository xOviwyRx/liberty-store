class CartsController < ApplicationController
  allow_unauthenticated_access

  def show
    @cart_items = current_cart.cart_items.includes(:product).order(:created_at)
  end
end
