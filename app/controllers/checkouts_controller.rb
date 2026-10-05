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
    session = create_stripe_session(order)
    redirect_to session.url, allow_other_host: true
  rescue PlaceOrder::InsufficientStock => e
    redirect_to cart_path, alert: e.message
  end

  private

  def create_stripe_session(order)
    Stripe::Checkout::Session.create(
      mode: "payment",
      customer_email: order.email,
      line_items: order.order_items.includes(:product).map { |item|
        {
          quantity: item.quantity,
          price_data: {
            currency: "eur",
            unit_amount: (item.unit_price * 100).round,
            product_data: { name: item.product.name }
          }
        }
      },
      metadata: { order_id: order.id },
      success_url: order_url(order.generate_token_for(:show)),
      cancel_url: cart_url
    )
  end

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
