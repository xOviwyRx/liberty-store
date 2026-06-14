require "rails_helper"

RSpec.describe CartItem, type: :model do
  describe "stock validation" do
    let(:product) { create(:product, inventory_count: 3) }

    it "is valid when the quantity is below the available stock" do
      item = build(:cart_item, product: product, quantity: 2)
      expect(item).to be_valid
    end

    it "is valid when the quantity equals the available stock" do
      item = build(:cart_item, product: product, quantity: 3)
      expect(item).to be_valid
    end

    it "is invalid when the quantity exceeds the available stock" do
      item = build(:cart_item, product: product, quantity: 4)
      expect(item).not_to be_valid
      expect(item.errors[:quantity]).to include("exceeds available stock")
    end
  end
end
