class PlaceOrder
  class InsufficientStock < StandardError; end

  def initialize(cart, email:, name:)
    @cart = cart
    @email = email
    @name = name
  end

  def call
    ApplicationRecord.transaction do
      order = Order.new(email: @email, name: @name, total: 0)

      @cart.cart_items.order(:product_id).each do |item|
        product = item.product.lock!

        if product.inventory_count < item.quantity
          raise InsufficientStock, "Not enough #{product.name} in stock"
        end

        product.update!(inventory_count: product.inventory_count - item.quantity)
        order.order_items.build(product: product, quantity: item.quantity, unit_price: product.price)
      end

      order.total = order.order_items.sum { |item| item.quantity * item.unit_price }
      order.save!
      @cart.destroy

      order
    end
  end
end
