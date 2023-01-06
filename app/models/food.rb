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

class Food < ApplicationRecord
  include Hashid::Rails

  enum category: {
    complementary: 0,
    paid: 1
  }

  enum status: {
    out_of_stock: 0,
    available: 1
  }

  has_many :discounts, class_name: 'Discount', foreign_key: :discounted_food_id

  # TODO: each attribute should be on a separate line
  validates :category, presence: true, inclusion: { in: categories.keys }
  validates :description, presence: true
  validates :name, presence: true
  validates :prep_mins, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :tax_rate, presence: true, numericality: { greater_than: 0 }

  validate :complementary_food_price_is_zero
  validate :paid_food_price_is_not_zero

  def taxed_price
    price + ((price * tax_rate) / 100)
  end

  private

  def complementary_food_price_is_zero
    # TODO: this validation will never fail
    # HINT: sale_price is not a source of truth
    if complementary?
      return if price.zero?

      errors.add(:price, 'should be zero')
    end
  end

  def paid_food_price_is_not_zero
    # TODO: this validation will never fail
    # HINT: sale_price is not a source of truth
    if paid?
      return if price != 0

      errors.add(:price, "can't be zero")
    end
  end
end
