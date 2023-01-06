module Api
  module V1
    class OrdersController < ApiController
      # TODO: do we really need to call current_method to be able to use it

      before_action :set_order, only: :show

      def index
        # REVIEW: check if we can do this here?
        # current_user.orders.includes(line_items: [:food])
        @pagy, @orders =
          pagy(
            current_user
              .orders
              .includes(line_items: [:food])
              .order(created_at: :desc)
          )

        # TODO: do we really need this?
      end

      def show; end

      def create
        # REVIEW:
        ActiveRecord::Base.transaction do
          @order = current_user.orders.create!(line_items: current_cart.line_items)

          current_cart.line_items.update_all(cart_id: nil)
        end

        return if @order.save

        render_attributes_errors(@order.errors)
      end

      private

      # TODO: do we need this?

      # TODO: do we need this?

      def set_order
        @order = Order.find_by_hashid!(params[:id])
        authorize @order
      end
    end
  end
end
