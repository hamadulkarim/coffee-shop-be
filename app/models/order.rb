# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  status     :integer          default("preparing"), not null
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
class Order < ApplicationRecord
  enum status: {
    preparing: 0,
    fulfilled: 1,
    pending: 2,
    cancelled: 3
  }

  belongs_to :user
  has_many :line_items, dependent: :destroy

  validates :line_items, presence: { message: 'must be added to place an order!' }
  validates :status, presence: true

  validate :should_have_one_paid_item

  delegate :sub_total, to: :bill_processor
  delegate :total_bill, to: :bill_processor
  delegate :total_discount, to: :bill_processor
  delegate :total_prep_time, to: :bill_processor

  private

  def bill_processor
    @bill_processor ||= BillProcessor.call(line_items)
  end

  def should_have_one_paid_item
    return if line_items.empty?
    return if line_items.any? { |item| item&.food&.paid? }

    errors.add(:order, 'should have at least one paid item')
  end
end
