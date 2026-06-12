require "rails_helper"

RSpec.describe "Carts", type: :request do
  describe "GET /cart" do
    it "shows an empty cart to a new visitor" do
      get cart_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Your cart is empty")
    end

    it "shows the visitor's items" do
      post cart_items_path, params: { product_id: create(:product).id }

      get cart_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(Product.last.name)
    end
  end
end
