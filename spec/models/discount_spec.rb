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
describe Discount, type: :model do
  subject(:discount) { create(:discount, discounted_food: discounted_food) }

  let(:discounted_food) { create(:food) }

  # resolve
  describe 'associations' do
    it do
      is_expected
        .to belong_to(:combination_food)
        .class_name('Food')
    end

    it do
      is_expected
        .to belong_to(:discounted_food)
        .class_name('Food')
    end
  end

  describe 'validations' do
    # resolve
    it do
      is_expected
        .to validate_uniqueness_of(:discounted_food_id)
        .scoped_to(:combination_food_id)
    end

    it do
      is_expected.to validate_presence_of(:discount_rate)
    end

    it do
      is_expected
        .to validate_numericality_of(:discount_rate)
        .is_greater_than(0)
        .is_less_than_or_equal_to(100)
    end
  end

  describe '#amount_discounted' do
    it 'returns the amount discounted on the food item' do
      amount = (discounted_food.price * discount.discount_rate / 100).round(3)
      expect(discount.amount_discounted).to eq(amount)
    end
  end
end
