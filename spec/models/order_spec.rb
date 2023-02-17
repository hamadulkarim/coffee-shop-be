describe Order, type: :model do
  subject(:order) { create(:order) }

  describe 'enums' do
    it do
      is_expected
        .to define_enum_for(:status)
        .with_values(%w[preparing fulfilled pending cancelled])
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
  end

  describe 'validations' do
    it {
      is_expected
        .to validate_presence_of(:line_items)
        .with_message('must be added to place an order!')
    }

    it { is_expected.to validate_presence_of(:status) }

    describe 'should_have_one_paid_item' do
      it 'is invalid with no paid food item' do
        order.line_items.first.food.update(category: 'complementary')

        expect(order).not_to be_valid
      end
    end
  end
end
