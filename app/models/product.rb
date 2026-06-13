class Product < ApplicationRecord
  include Notifications
  include Broadcasts

  has_one_attached :featured_image
  has_rich_text :description
  normalizes :name, with: ->(name) { name.strip }
  validates :name, presence: true
  validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
