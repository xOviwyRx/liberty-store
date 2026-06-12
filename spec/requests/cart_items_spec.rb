require "rails_helper"

RSpec.describe "CartItems", type: :request do
  let(:product) { create(:product) }

  describe "POST /cart_items" do
    it "adds the product to the cart" do
      expect {
        post cart_items_path, params: { product_id: product.id }
      }.to change(CartItem, :count).by(1)
    end

    it "increments quantity when the product is already in the cart" do
      post cart_items_path, params: { product_id: product.id }

      expect {
        post cart_items_path, params: { product_id: product.id }
      }.not_to change(CartItem, :count)

      expect(CartItem.last.quantity).to eq(2)
    end

    it "redirects with an alert for an unknown product" do
      expect {
        post cart_items_path, params: { product_id: 0 }
      }.not_to change(CartItem, :count)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Product not found.")
    end
  end

  describe "PATCH /cart_items/:id" do
    it "updates the quantity" do
      post cart_items_path, params: { product_id: product.id }
      item = CartItem.last

      patch cart_item_path(item), params: { cart_item: { quantity: 5 } }

      expect(item.reload.quantity).to eq(5)
    end

    it "ignores quantities below 1" do
      post cart_items_path, params: { product_id: product.id }
      item = CartItem.last

      patch cart_item_path(item), params: { cart_item: { quantity: 0 } }

      expect(item.reload.quantity).to eq(1)
    end

    it "does not touch items in another visitor's cart" do
      other_item = create(:cart_item)

      patch cart_item_path(other_item), params: { cart_item: { quantity: 99 } }

      expect(other_item.reload.quantity).to eq(1)
      expect(flash[:alert]).to eq("Item not found.")
    end
  end

  describe "DELETE /cart_items/:id" do
    it "removes the item from the cart" do
      post cart_items_path, params: { product_id: product.id }
      item = CartItem.last

      expect {
        delete cart_item_path(item)
      }.to change(CartItem, :count).by(-1)
    end
  end
end
