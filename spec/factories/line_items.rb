FactoryBot.define do
  factory :line_item do
    association :food, factory: :food

    quantity { Faker::Number.between(from: 1, to: 10) }

    for_cart

    trait :for_cart do
      association :cart
      order { nil }
    end

    trait :for_order do
      association :order
      cart { nil }
    end
  end
end
