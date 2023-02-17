# frozen_string_literal: true

# == Schema Information
#
# Table name: foods
#
#  id          :bigint           not null, primary key
#  category    :integer          default("complementary"), not null
#  description :string           default(""), not null
#  name        :string           default(""), not null
#  prep_mins   :integer          default(0), not null
#  price       :float            default(0.0), not null
#  status      :integer          default("out_of_stock"), not null
#  tax_rate    :float            default(0.0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Food < ApplicationRecord
  enum category: {
    complementary: 0,
    paid: 1
  }

  enum status: {
    out_of_stock: 0,
    available: 1
  }

  has_many :discounts, class_name: 'Discount', foreign_key: :discounted_food_id, dependent: :destroy
  has_many :line_items, dependent: :destroy

  validates :category, presence: true
  validates :description, presence: true
  validates :name, presence: true
  validates :prep_mins, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validates :tax_rate, presence: true, numericality: { greater_than: 0 }

  validate :complementary_food_price_is_zero
  validate :paid_food_price_is_not_zero

  def taxed_price
    (price + ((price * tax_rate) / 100)).round(3)
  end

  private

  def complementary_food_price_is_zero
    return unless complementary? && price.positive?

    errors.add(:price, 'should be zero')
  end

  def paid_food_price_is_not_zero
    return unless paid? && price&.zero?

    errors.add(:price, "can't be zero")
  end
end
