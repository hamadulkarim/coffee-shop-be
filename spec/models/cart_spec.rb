describe Cart, type: :model do
  subject { create(:cart) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
    it { is_expected.to have_many(:foods).through(:line_items) }
  end
end
