class UpdateOrderJob < ApplicationJob
  queue_as :default

  def perform
    pending_orders ||= Order.pending

    pending_orders.each do |order|
      if (Time.zone.now - order.created_at) / 1.minute > order.total_prep_time
        order.update(status: 'fulfilled')
      end
    end
  end
end
