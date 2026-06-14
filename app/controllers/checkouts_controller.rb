class CheckoutsController < ApplicationController
  allow_unauthenticated_access
  before_action :require_items_in_cart
  before_action :load_cart_items

  def new
    @checkout = CheckoutForm.new
  end

  def create
    @checkout = CheckoutForm.new(checkout_params)
    return render :new, status: :unprocessable_entity unless @checkout.valid?

    order = PlaceOrder.new(current_cart, email: @checkout.email, name: @checkout.name).call
    redirect_to order_path(order.generate_token_for(:show))
  rescue PlaceOrder::InsufficientStock => e
    redirect_to cart_path, alert: e.message
  end

  private

  def require_items_in_cart
    redirect_to cart_path, alert: "Your cart is empty." if current_cart.cart_items.none?
  end

  def load_cart_items
    @cart_items = current_cart.cart_items.includes(:product)
  end

  def checkout_params
    params.expect(checkout: [ :email, :name ])
  end
end
