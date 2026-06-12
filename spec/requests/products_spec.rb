require "rails_helper"

RSpec.describe "Products", type: :request do
  describe "GET /products" do
    it "shows the catalog to guests" do
      product = create(:product)

      get products_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end
  end

  describe "POST /products" do
    it "redirects guests to login" do
      post products_path, params: { product: { name: "Lamp", inventory_count: 3 } }

      expect(response).to redirect_to(new_session_path)
    end

    context "when signed in" do
      before { sign_in create(:user) }

      it "creates a product" do
        expect {
          post products_path, params: { product: { name: "Lamp", inventory_count: 3, price: 19.99 } }
        }.to change(Product, :count).by(1)
      end

      it "does not create a product without a name" do
        expect {
          post products_path, params: { product: { name: "", inventory_count: 3, price: 19.99 } }
        }.not_to change(Product, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
