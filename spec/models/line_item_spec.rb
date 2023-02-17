describe LineItem, type: :model do
  subject(:line_item) { create(:line_item, food: food, quantity: 2) }

  let(:order) { create(:order) }
  let(:food) { create(:food, price: 5.5, tax_rate: 3.5) }

  describe 'associations' do
    it { is_expected.to belong_to(:cart).optional }
    it { is_expected.to belong_to(:food) }
    it { is_expected.to belong_to(:order).optional }
  end

  describe 'validations' do
    it do
      line_item.update(order_id: nil)

      expect(line_item).to validate_presence_of(:cart_id)
    end

    it do
      is_expected
        .to validate_uniqueness_of(:food_id)
        .scoped_to(:cart_id)
    end

    it do
      line_item.update(cart_id: nil, order_id: order.id)

      expect(line_item).to validate_presence_of(:order_id)
    end

    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }

    describe 'food_is_in_stock' do
      it 'is invalid when food is out of stock' do
        food = create(:food, status: :out_of_stock)
        out_of_stock_item = build(:line_item, food: food)

        expect(out_of_stock_item).not_to be_valid
      end
    end
  end

  describe '#total_price' do
    it 'returns the total price for the line item with respect to its quantity' do
      total_price = 11.386

      expect(line_item.total_price).to eq(total_price)
    end
  end
end
