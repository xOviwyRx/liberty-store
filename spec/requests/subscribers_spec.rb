require "rails_helper"

RSpec.describe "Subscribers", type: :request do
  describe "POST /products/:product_id/subscribers" do
    let(:product) { create(:product, :out_of_stock) }

    it "subscribes an email and confirms" do
      expect {
        post product_subscribers_path(product), params: { subscriber: { email: "fan@example.com" } }
      }.to change(Subscriber, :count).by(1)

      expect(response).to redirect_to(product_path(product))
      expect(flash[:notice]).to eq("You are now subscribed.")
    end

    it "shows a friendly notice for an existing subscription" do
      create(:subscriber, product: product, email: "fan@example.com")

      expect {
        post product_subscribers_path(product), params: { subscriber: { email: "FAN@example.com" } }
      }.not_to change(Subscriber, :count)

      expect(flash[:notice]).to eq("You are already subscribed.")
    end

    it "shows the error for an invalid email" do
      expect {
        post product_subscribers_path(product), params: { subscriber: { email: "not-an-email" } }
      }.not_to change(Subscriber, :count)

      expect(flash[:alert]).to be_present
    end
  end
end
