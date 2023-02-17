# == Schema Information
#
# Table name: line_items
#
#  id         :bigint           not null, primary key
#  quantity   :integer          default(1), not null
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
class LineItem < ApplicationRecord
  belongs_to :cart, optional: true
  belongs_to :food
  belongs_to :order, optional: true

  validates :cart_id, presence: true, unless: -> { order_id? }
  validates :food_id, uniqueness: { scope: :cart_id }
  validates :order_id, presence: true, unless: -> { cart_id? }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }

  validate :food_is_in_stock, on: :create

  def total_price
    (quantity * food.taxed_price).round(3)
  end

  private

  def food_is_in_stock
    return if food&.status == 'available'

    errors.add(:food, 'should be available')
  end
end
