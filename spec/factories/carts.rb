FactoryBot.define do
  factory :cart do
    association :user

    trait :with_items do
      after(:create) do |cart|
        create_list(:line_item, 4, cart: cart)
      end
    end
  end
end
