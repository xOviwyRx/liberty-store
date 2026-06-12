class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total
    cart_items.joins(:product).sum("products.price * cart_items.quantity")
  end

  def item_count
    cart_items.sum(:quantity)
  end
end
