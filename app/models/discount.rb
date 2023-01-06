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

class Discount < ApplicationRecord
  include Hashid::Rails

  belongs_to :combination_food, class_name: 'Food'
  belongs_to :discounted_food, class_name: 'Food'

  validates :discounted_food_id, uniqueness: { scope: :combination_food_id }
  validates :discount_rate, presence: true,
                            numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  validate :not_on_complementary_foods

  def amount_discounted
    (discounted_food.price * discount_rate / 100).round(3)
  end

  private

  def not_on_complementary_foods
    # resolve
    return if discounted_food.paid? && combination_food.paid?

    errors.add(:order, 'can not be created on complementary foods')
  end
end
