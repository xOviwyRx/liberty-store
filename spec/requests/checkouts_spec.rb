require "rails_helper"

RSpec.describe "Checkouts", type: :request do
  let(:product) { create(:product, inventory_count: 5) }

  def add_to_cart(item, quantity: 1)
    quantity.times { post cart_items_path, params: { product_id: item.id } }
  end

  describe "GET /checkout/new" do
    it "renders the checkout form when the cart has items" do
      add_to_cart(product)

      get new_checkout_path

      expect(response).to have_http_status(:ok)
    end

    context "when the cart is empty" do
      it "redirects to the cart" do
        get new_checkout_path

        expect(response).to redirect_to(cart_path)
      end
    end
  end

  describe "POST /checkout" do
    let(:valid_details) { { checkout: { name: "Ada Lovelace", email: "ada@example.com" } } }

    it "places the order and redirects to its confirmation" do
      add_to_cart(product)

      expect {
        post checkout_path, params: valid_details
      }.to change(Order, :count).by(1)

      expect(response).to redirect_to(order_path(Order.last.generate_token_for(:show)))
    end

    context "with invalid details" do
      it "does not create an order" do
        add_to_cart(product)

        expect {
          post checkout_path, params: { checkout: { name: "", email: "nope" } }
        }.not_to change(Order, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when an item is out of stock" do
      it "redirects to the cart without creating an order" do
        add_to_cart(product, quantity: 2)
        product.update!(inventory_count: 1)

        expect {
          post checkout_path, params: valid_details
        }.not_to change(Order, :count)

        expect(response).to redirect_to(cart_path)
      end
    end
  end
end
