# frozen_string_literal: true

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

FactoryBot.define do
  factory :food do
    description { Faker::Food.description }
    name { Faker::Food.dish }
    prep_mins { Faker::Number.between(from: 1, to: 9) }
    status { 'available' }
    tax_rate { Faker::Number.between(from: 1, to: 49) }

    paid

    trait :complementary do
      category { 'complementary' }
      price { 0 }
    end

    trait :paid do
      category { 'paid' }
      price { Faker::Commerce.price }
    end
  end
end
