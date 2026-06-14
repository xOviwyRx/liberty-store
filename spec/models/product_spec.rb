require "rails_helper"

RSpec.describe Product, type: :model do
  it "requires a name" do
    expect(build(:product, name: nil)).not_to be_valid
  end

  it "rejects a negative inventory count" do
    expect(build(:product, inventory_count: -1)).not_to be_valid
  end

  it "requires an inventory count" do
    expect(build(:product, inventory_count: nil)).not_to be_valid
  end

  it "rejects an inventory count above the limit" do
    expect(build(:product, inventory_count: Product::INVENTORY_LIMIT + 1)).not_to be_valid
  end

  it "rejects a price above the limit" do
    expect(build(:product, price: Product::PRICE_LIMIT + 1)).not_to be_valid
  end
end
