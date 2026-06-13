require "rails_helper"

RSpec.describe Product::Broadcasts, type: :model do
  describe "live stock broadcast" do
    it "broadcasts when inventory changes" do
      product = create(:product, inventory_count: 5)

      expect {
        product.update!(inventory_count: 0)
      }.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob).twice
    end

    it "does not broadcast when inventory is unchanged" do
      product = create(:product, inventory_count: 5)

      expect {
        product.update!(name: "Renamed Product")
      }.not_to have_enqueued_job(Turbo::Streams::ActionBroadcastJob)
    end
  end
end
