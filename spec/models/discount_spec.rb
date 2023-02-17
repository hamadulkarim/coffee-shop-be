describe Discount, type: :model do
  subject(:discount) { create(:discount, discounted_food: discounted_food, discount_rate: 2.5) }

  let(:discounted_food) { create(:food, price: 5.5) }

  describe 'associations' do
    it { is_expected.to belong_to(:combination_food).class_name('Food') }
    it { is_expected.to belong_to(:discounted_food).class_name('Food') }
  end

  describe 'validations' do
    it do
      is_expected
        .to validate_uniqueness_of(:discounted_food_id)
        .scoped_to(:combination_food_id)
    end

    it { is_expected.to validate_presence_of(:discount_rate) }

    it do
      is_expected
        .to validate_numericality_of(:discount_rate)
        .is_greater_than(0)
        .is_less_than_or_equal_to(100)
    end

    describe 'not_on_complementary_foods' do
      it do
        discount.discounted_food.update(category: 'complementary', price: 0)

        expect(discount).not_to be_valid
      end
    end
  end

  describe '#amount_discounted' do
    it 'returns the amount discounted on the food item' do
      amount = 0.138
      expect(discount.amount_discounted).to eq(amount)
    end
  end
end
