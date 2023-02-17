FactoryBot.define do
  factory :food do
    description { Faker::Food.description }
    name { Faker::Food.dish }
    prep_mins { Faker::Number.between(from: 1, to: 9) }
    status { 'available' }
    tax_rate { Faker::Number.between(from: 1, to: 49) }

    paid

    trait :complementary do
      category { 'complementary' }
      price { 0 }
    end

    trait :paid do
      category { 'paid' }
      price { Faker::Commerce.price(range: 0..50.0) }
    end
  end
end
