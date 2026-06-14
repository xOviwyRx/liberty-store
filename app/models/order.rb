class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  generates_token_for :show

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :name, with: ->(name) { name.strip }

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }
end
