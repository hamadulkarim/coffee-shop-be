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

class Cart < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :foods, through: :line_items

  delegate :sub_total, to: :bill_processor
  delegate :total_bill, to: :bill_processor
  delegate :total_discount, to: :bill_processor
  delegate :total_prep_time, to: :bill_processor

  private

  def bill_processor
    @bill_processor ||= BillProcessor.call(line_items)
  end
end
