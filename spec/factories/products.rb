FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    inventory_count { 10 }

    trait :out_of_stock do
      inventory_count { 0 }
    end
  end
end
