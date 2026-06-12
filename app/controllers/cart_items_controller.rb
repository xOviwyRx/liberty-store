class CartItemsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_cart_item, only: %i[ update destroy ]

  def create
    product = Product.find_by(id: params[:product_id])
    return redirect_to root_path, alert: "Product not found." unless product

    item = current_cart.cart_items.find_or_initialize_by(product: product)
    item.quantity = item.quantity.to_i + 1

    if item.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back_or_to product }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = item.errors.full_messages.to_sentence }
        format.html { redirect_back_or_to product, alert: item.errors.full_messages.to_sentence }
      end
    end
  end

  def update
    quantity = cart_item_params[:quantity].to_i

    @cart_item.update!(quantity: quantity) if quantity >= 1

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path }
    end
  end

  def destroy
    @cart_item.destroy

    respond_to do |format|
      format.turbo_stream { redirect_to cart_path if current_cart.cart_items.none? }
      format.html { redirect_to cart_path }
    end
  end

  private

  def set_cart_item
    @cart_item = current_cart.cart_items.find_by(id: params[:id])
    redirect_to cart_path, alert: "Item not found." unless @cart_item
  end

  def cart_item_params
    params.expect(cart_item: [ :quantity ])
  end
end
