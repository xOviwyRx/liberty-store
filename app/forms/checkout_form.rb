class CheckoutForm
  include ActiveModel::Model

  attr_accessor :email, :name

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { maximum: 100 }
end
