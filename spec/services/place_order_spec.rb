require "rails_helper"

RSpec.describe PlaceOrder do
  subject(:place_order) { described_class.new(cart, email: "ada@example.com", name: "Ada Lovelace").call }

  let(:cart) { create(:cart) }
  let(:lamp) { create(:product, price: 20, inventory_count: 5) }
  let(:mug) { create(:product, price: 8, inventory_count: 10) }

  before do
    create(:cart_item, cart: cart, product: lamp, quantity: 2)
    create(:cart_item, cart: cart, product: mug, quantity: 3)
  end

  it "creates an order" do
    expect { place_order }.to change(Order, :count).by(1)
  end

  it "snapshots each line's product, quantity, and price" do
    lines = place_order.order_items.order(:product_id)

    expect(lines.pluck(:product_id, :quantity, :unit_price)).to eq(
      [ [ lamp.id, 2, 20 ], [ mug.id, 3, 8 ] ]
    )
  end

  it "sets the total to the sum of the line items" do
    expect(place_order.total).to eq(64)
  end

  it "decrements each product's inventory by the quantity ordered" do
    place_order

    expect(lamp.reload.inventory_count).to eq(3)
    expect(mug.reload.inventory_count).to eq(7)
  end

  it "destroys the cart" do
    place_order

    expect(Cart.exists?(cart.id)).to be(false)
  end

  context "when a product has exactly enough stock for the quantity ordered" do
    before { lamp.update!(inventory_count: 2) }

    it "places the order and leaves that product out of stock" do
      expect { place_order }.to change(Order, :count).by(1)
      expect(lamp.reload.inventory_count).to eq(0)
    end
  end

  context "when a product has less stock than the quantity ordered" do
    before { mug.update!(inventory_count: 1) }

    it "does NOT create an order and raises InsufficientStock" do
      expect { place_order }.to raise_error(PlaceOrder::InsufficientStock)
      expect(Order.count).to eq(0)
    end
  end
end
