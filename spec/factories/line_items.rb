# == Schema Information
#
# Table name: line_items
#
#  id         :bigint           not null, primary key
#  quantity   :integer          default(2), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cart_id    :bigint           indexed
#  food_id    :bigint           not null, indexed
#  order_id   :bigint           indexed
#
# Indexes
#
#  index_line_items_on_cart_id   (cart_id)
#  index_line_items_on_food_id   (food_id)
#  index_line_items_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (cart_id => carts.id)
#  fk_rails_...  (food_id => foods.id)
#  fk_rails_...  (order_id => orders.id)
#

FactoryBot.define do
  factory :line_item do
    association :food

    quantity { Faker::Number.between(from: 1, to: 10) }

    # TODO: what is for cart here?
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
