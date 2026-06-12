module CurrentCart
  extend ActiveSupport::Concern

  included do
    helper_method :current_cart
  end

  private

  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def find_or_create_cart
    cart = Cart.find_by(id: cookies.signed[:cart_id])
    return cart if cart

    cart = Cart.create!
    cookies.permanent.signed[:cart_id] = cart.id
    cart
  end
end
