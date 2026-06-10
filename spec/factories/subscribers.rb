FactoryBot.define do
  factory :subscriber do
    product
    sequence(:email) { |n| "subscriber#{n}@example.com" }
  end
end
