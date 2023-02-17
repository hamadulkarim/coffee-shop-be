class UpdateOrderJob < ApplicationJob
  queue_as :default

  def perform
    orders_to_update = prepared_orders

    orders_to_update.each do |order|
      order.update(status: 'fulfilled')

      OrderStatusMailer.with(user: order.user, order: order).send_status.deliver_now
    end
  end

  def prepared_orders
    Order
      .includes(line_items: [:food])
      .preparing
      .select do |order|
        (Time.zone.now - order.created_at) / 1.minute > order.total_prep_time
      end
  end
end
