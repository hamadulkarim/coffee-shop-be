# == Schema Information
#
# Table name: foods
#
#  id          :bigint           not null, primary key
#  category    :integer          default("paid"), not null
#  description :string           default("Italian food"), not null
#  name        :string           default("Pizza"), not null
#  prep_mins   :integer          default(5), not null
#  price       :float            default(8.99), not null
#  status      :integer          default("out_of_stock"), not null
#  tax_rate    :float            default(11.3), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
describe Food, type: :model do
  subject(:food) { create(:food) }

  describe 'associations' do
    it do
      is_expected.to have_many(:discounts).class_name('Discount')
    end
  end

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

  describe 'validations' do
    it do
      is_expected.to validate_numericality_of(:prep_mins).is_greater_than(0)
    end

    it do
      is_expected.to validate_numericality_of(:tax_rate).is_greater_than(0)
    end

    it do
      is_expected.to validate_presence_of(:category)
    end

    it do
      is_expected.to validate_presence_of(:description)
    end

    it do
      is_expected.to validate_presence_of(:name)
    end

    it do
      is_expected.to validate_presence_of(:prep_mins)
    end

    it do
      is_expected.to validate_presence_of(:price)
    end

    it do
      is_expected.to validate_presence_of(:status)
    end

    it do
      is_expected.to validate_presence_of(:tax_rate)
    end
  end
end
