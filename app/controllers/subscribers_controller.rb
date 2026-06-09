class SubscribersController < ApplicationController
  allow_unauthenticated_access
  before_action :set_product

  def create
    subscriber = @product.subscribers.new(subscriber_params)

    if subscriber.save
      redirect_to @product, notice: "You are now subscribed."
    elsif subscriber.errors.where(:email, :taken).any?
      redirect_to @product, notice: "You are already subscribed."
    else
      redirect_to @product, alert: subscriber.errors.full_messages.to_sentence
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def subscriber_params
    params.expect(subscriber: [ :email ])
  end
end
