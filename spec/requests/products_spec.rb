require "rails_helper"

RSpec.describe "Products", type: :request do
  describe "GET /products" do
    it "shows the catalog to guests" do
      product = create(:product)

      get products_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end

    it "filters the catalog by the search query" do
      lamp = create(:product, name: "Blue Lamp")
      chair = create(:product, name: "Red Chair")

      get products_path(q: "lamp")

      expect(response.body).to include(lamp.name)
      expect(response.body).not_to include(chair.name)
    end

    it "filters the catalog to in-stock products" do
      available = create(:product, name: "Blue Lamp", inventory_count: 3)
      sold_out = create(:product, name: "Red Chair", inventory_count: 0)

      get products_path(in_stock: "1")

      expect(response.body).to include(available.name)
      expect(response.body).not_to include(sold_out.name)
    end

    it "filters the catalog by a price range" do
      cheap = create(:product, name: "Cheap Lamp", price: 10)
      mid = create(:product, name: "Mid Chair", price: 30)
      pricey = create(:product, name: "Pricey Sofa", price: 100)

      get products_path(min_price: "20", max_price: "50")

      expect(response.body).to include(mid.name)
      expect(response.body).not_to include(cheap.name)
      expect(response.body).not_to include(pricey.name)
    end

    it "sorts the catalog by price ascending" do
      cheap = create(:product, name: "Cheap Lamp", price: 10)
      pricey = create(:product, name: "Pricey Sofa", price: 100)

      get products_path(sort: "price_asc")

      expect(response.body.index(cheap.name)).to be < response.body.index(pricey.name)
    end

    it "lists in-stock products before out-of-stock ones" do
      available = create(:product, name: "Available Chair")
      sold_out = create(:product, :out_of_stock, name: "Sold Out Lamp")

      get products_path

      expect(response.body.index(available.name)).to be < response.body.index(sold_out.name)
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
