require "rails_helper"

RSpec.describe "Unsubscribes", type: :request do
  describe "GET /unsubscribe" do
    it "unsubscribes with a valid token" do
      subscriber = create(:subscriber)
      token = subscriber.generate_token_for(:unsubscribe)

      expect {
        get unsubscribe_path(token: token)
      }.to change(Subscriber, :count).by(-1)

      expect(response).to redirect_to(root_path)
    end

    it "does not unsubscribe with an invalid token" do
      create(:subscriber)

      expect {
        get unsubscribe_path(token: "bogus")
      }.not_to change(Subscriber, :count)

      expect(flash[:alert]).to be_present
    end
  end
end
