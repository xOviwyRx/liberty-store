# Idempotent development seed data. Safe to run repeatedly with `bin/rails db:seed`.
#
# Guarded to development only: seeds run in every environment, and a known-password
# admin must never be auto-created in production. Create the production admin
# manually via `bin/kamal console`.
if Rails.env.development?
  admin_email    = "admin@example.com"
  admin_password = "Liberty!Admin2026"

  admin = User.find_or_create_by!(email_address: admin_email) do |user|
    user.password              = admin_password
    user.password_confirmation = admin_password
  end
  products = [
    { name: "Aeron Chair",         inventory_count: 12, description: "Ergonomic office chair with a breathable mesh back." },
    { name: "Standing Desk",       inventory_count: 5,  description: "Height-adjustable desk for sitting or standing." },
    { name: "Mechanical Keyboard", inventory_count: 0,  description: "Tactile keyboard with hot-swappable switches." },
    { name: "4K Studio Monitor",   inventory_count: 8,  description: "27-inch 4K display with accurate color." }
  ]

  products.each do |attrs|
    Product.find_or_create_by!(name: attrs[:name]) do |product|
      product.inventory_count = attrs[:inventory_count]
      product.description     = attrs[:description]
    end
  end
end
