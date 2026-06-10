require "rails_helper"

RSpec.describe Product::Notifications, type: :model do
  it "emails each subscriber when an out-of-stock product is restocked" do
    product = create(:product, :out_of_stock)
    create_list(:subscriber, 2, product: product)

    expect { product.update!(inventory_count: 99) }
      .to have_enqueued_mail(ProductMailer, :in_stock).twice
  end

  it "does not email when an in-stock product changes inventory" do
    product = create(:product, inventory_count: 5)
    create(:subscriber, product: product)

    expect { product.update!(inventory_count: 10) }
      .not_to have_enqueued_mail(ProductMailer, :in_stock)
  end
end
