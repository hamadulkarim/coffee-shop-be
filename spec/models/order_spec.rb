# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null, indexed
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
describe Order, type: :model do
  subject(:order) { create(:order) }

  describe 'associations' do
    it do
      is_expected.to belong_to(:user)
    end

    it do
      is_expected.to have_many(:line_items).dependent(:destroy)
    end
  end

  describe 'enums' do
    it do
      is_expected
        .to define_enum_for(:status)
        .with_values(%w[pending fulfilled cancelled])
    end
  end

  describe 'validations' do
    it do
      is_expected.to validate_presence_of(:line_items)
    end

    it do
      is_expected.to validate_presence_of(:status)
    end
  end
end
