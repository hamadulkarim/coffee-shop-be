FactoryBot.define do
  factory :order do
    association :user

    after(:build) do |order|
      order.save(validate: false)
      create_list(:line_item, 1, :for_order, order: order)
    end
  end
end
