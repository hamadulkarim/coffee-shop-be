# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string           indexed
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           not null, indexed
#  encrypted_password     :string           not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  must_change_password   :boolean          default(FALSE)
#  provider               :string           default("email"), not null, indexed => [uid]
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string           indexed
#  role                   :integer          default("customer")
#  sign_in_count          :integer          default(0)
#  tokens                 :json             not null
#  uid                    :string           not null, indexed => [provider]
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

describe User, type: :model do
  subject(:user) { create(:user) }

  describe 'associations' do
    it do
      is_expected.to have_one(:cart).dependent(:destroy)
    end

    it do
      is_expected.to have_many(:orders).dependent(:destroy)
    end
  end

  describe 'enums' do
    it do
      is_expected
        .to define_enum_for(:role)
        .with_values(%w[customer shopkeeper])
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
  end
end
