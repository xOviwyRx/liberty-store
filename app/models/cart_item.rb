class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id, uniqueness: { scope: :cart_id }
  validate :quantity_within_stock

  private

  def quantity_within_stock
    return if product.nil? || quantity.nil?

    if quantity > product.inventory_count
      errors.add(:quantity, "exceeds available stock")
    end
  end
end
