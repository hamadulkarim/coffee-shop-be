# == Schema Information
#
# Table name: discounts
#
#  id                  :bigint           not null, primary key
#  discount_rate       :float            default(20.3), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  combination_food_id :bigint           not null, indexed
#  discounted_food_id  :bigint           not null, indexed
#
# Indexes
#
#  index_discounts_on_combination_food_id  (combination_food_id)
#  index_discounts_on_discounted_food_id   (discounted_food_id)
#
# Foreign Keys
#
#  fk_rails_...  (combination_food_id => foods.id)
#  fk_rails_...  (discounted_food_id => foods.id)
#

FactoryBot.define do
  factory :discount do
    association :discounted_food, factory: :food
    association :combination_food, factory: :food

    discount_rate { Faker::Number.between(from: 1, to: 100) }
  end
end
