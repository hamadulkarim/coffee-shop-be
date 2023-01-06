# == Schema Information
#
# Table name: carts
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null, indexed
#
# Indexes
#
#  index_carts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
describe Cart, type: :model do
  subject(:cart) { create(:cart) }

  describe 'associations' do
    it do
      is_expected.to belong_to(:user)
    end

    it do
      is_expected
        .to have_many(:line_items)
        .dependent(:destroy)
    end

    it do
      is_expected
        .to have_many(:foods)
        .through(:line_items)
    end
  end

  # TODO: missing specs for enums
  # TODO: missing specs for validations
end
