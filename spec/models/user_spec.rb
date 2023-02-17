describe User, type: :model do
  subject(:user) { create(:user) }

  describe 'enums' do
    it do
      is_expected
        .to define_enum_for(:role)
        .with_values(%w[customer shopkeeper])
    end
  end

  describe 'associations' do
    it { is_expected.to have_one(:cart).dependent(:destroy) }

    it { is_expected.to have_many(:orders).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }

    it do
      is_expected
        .to validate_uniqueness_of(:email)
        .scoped_to(:provider)
        .case_insensitive
    end

    describe 'only_one_shopkeeper' do
      it do
        user.update(role: 'shopkeeper')
        shopkeeper = build(:user, role: 'shopkeeper')

        expect(shopkeeper).not_to be_valid
      end
    end
  end
end
