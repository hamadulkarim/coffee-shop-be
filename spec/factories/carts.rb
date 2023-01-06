FactoryBot.define do
  factory :cart do
    association :user

    trait :with_item do
      after(:create) do |cart|
        create_list(:line_item, 1, cart: cart)
      end
    end
  end
end
