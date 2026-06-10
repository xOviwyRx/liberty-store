require "rails_helper"

RSpec.describe Subscriber, type: :model do
  describe "validations" do
    it "is valid with a product and email" do
      expect(build(:subscriber)).to be_valid
    end

    it "requires an email" do
      subscriber = build(:subscriber, email: nil)
      expect(subscriber).not_to be_valid
      expect(subscriber.errors[:email]).to include("can't be blank")
    end

    it "rejects a malformed email" do
      subscriber = build(:subscriber, email: "not-an-email")
      expect(subscriber).not_to be_valid
    end

    it "requires a product" do
      subscriber = build(:subscriber, product: nil)
      expect(subscriber).not_to be_valid
    end

    it "rejects a duplicate email on the same product (case-insensitively)" do
      existing = create(:subscriber, email: "fan@example.com")
      duplicate = build(:subscriber, product: existing.product, email: "FAN@example.com")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("has already been taken")
    end

    it "allows the same email on different products" do
      create(:subscriber, email: "fan@example.com")
      other = build(:subscriber, email: "fan@example.com")
      expect(other).to be_valid
    end
  end

  describe "normalization" do
    it "strips and downcases the email before saving" do
      subscriber = create(:subscriber, email: "  Fan@Example.COM  ")
      expect(subscriber.email).to eq("fan@example.com")
    end
  end
end
