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
describe LineItem, type: :model do
  subject(:line_item) { create(:line_item) }

  describe 'associations' do
    it do
      is_expected.to belong_to(:cart).optional
    end

    # resolve
    it do
      is_expected.to belong_to(:food)
    end

    it do
      is_expected.to belong_to(:order).optional
    end
  end

  describe 'validations' do
    it do
      is_expected
        .to validate_numericality_of(:quantity)
        .is_greater_than_or_equal_to(1)
    end

    it do
      is_expected.to validate_presence_of(:quantity)
    end

    it do
      is_expected
        .to validate_uniqueness_of(:food_id)
        .scoped_to(:cart_id)
    end
  end
end
