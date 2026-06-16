class Product < ApplicationRecord
  include Notifications
  include Broadcasts

  INVENTORY_LIMIT = 1_000_000_000
  PRICE_LIMIT     = 99_999_999.99

  has_one_attached :featured_image
  has_rich_text :description
  normalizes :name, with: ->(name) { name.strip }
  validates :name, presence: true
  validates :inventory_count, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: INVENTORY_LIMIT }
  validates :price, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: PRICE_LIMIT }

  def self.search(query)
    return all if query.blank?

    where("name ILIKE ?", "%#{sanitize_sql_like(query)}%")
  end

  scope :in_stock, -> { where("inventory_count > 0") }
end
