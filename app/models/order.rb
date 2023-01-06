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
class Order < ApplicationRecord
  include Hashid::Rails

  enum status: {
    pending: 0,
    fulfilled: 1,
    cancelled: 2
  }

  belongs_to :user

  has_many :line_items, dependent: :destroy

  validates :line_items, presence: true
  validates :status, inclusion: { in: statuses.keys }, presence: true

  validate :can_have_one_complementary_item
  validate :should_have_an_item
  validate :should_have_one_paid_item

  delegate :sub_total, to: :bill_processor

  delegate :total_bill, to: :bill_processor

  delegate :total_discount, to: :bill_processor

  delegate :total_prep_time, to: :bill_processor

  private

  # TODO: do we need to memoize this
  def bill_processor
    @bill_processor ||= BillProcessor.call(line_items)
  end

  def can_have_one_complementary_item
    return if line_items.map { |item|
                item.food.complementary?
              }.count(true) <= 1

    errors.add(:order, 'can not have more than one complementary items')
  end

  def should_have_an_item
    return if line_items.present?

    errors.add(:order, 'should have at least one line item')
  end

  def should_have_one_paid_item
    # TODO: can we use any? method here?
    line_items.any? do |item|
      return if item.food.paid?
    end

    errors.add(:order, 'should have at least one paid item')
  end
end
