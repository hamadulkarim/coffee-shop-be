FactoryBot.define do
  factory :discount do
    association :discounted_food, factory: :food
    association :combination_food, factory: :food

    discount_rate { Faker::Number.between(from: 1, to: 100) }
  end
end
