describe Food, type: :model do
  subject(:food) { create(:food, price: 5.5, tax_rate: 3.5) }

  describe 'enums' do
    it do
      is_expected
        .to define_enum_for(:category)
        .with_values(%w[complementary paid])
    end

    it do
      is_expected
        .to define_enum_for(:status)
        .with_values(%w[out_of_stock available])
    end
  end

  describe 'associations' do
    it do
      is_expected
        .to have_many(:discounts)
        .class_name('Discount')
        .with_foreign_key(:discounted_food_id)
        .dependent(:destroy)
    end

    it do
      is_expected
        .to have_many(:line_items)
        .dependent(:destroy)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:prep_mins) }
    it { is_expected.to validate_numericality_of(:prep_mins).is_greater_than(0) }

    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:tax_rate) }
    it { is_expected.to validate_numericality_of(:tax_rate).is_greater_than(0) }

    describe 'complementary_food_price_is_zero' do
      it 'is valid when price is zero' do
        food.update(category: 'complementary', price: 0)
        expect(food).to be_valid
      end

      it 'is invalid when price is not zero' do
        food.update(category: 'complementary', price: 4)
        expect(food).not_to be_valid
      end
    end

    describe 'paid_food_price_is_not_zero' do
      it 'is valid when price is not zero' do
        food.update(category: 'paid', price: 4)
        expect(food).to be_valid
      end

      it 'is invalid when price is zero' do
        food.update(category: 'paid', price: 0)
        expect(food).not_to be_valid
      end
    end
  end

  describe '#taxed_price' do
    it 'returns the taxed price of the food item' do
      taxed_price = 5.693
      expect(food.taxed_price).to eq(taxed_price)
    end
  end
end
