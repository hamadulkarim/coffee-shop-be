module Api
  module V1
    module Shopkeeper
      class OrdersController < BaseController
        before_action :set_order, only: %i[show update]

        def index
          @pagy, @orders =
            pagy(
              Order
                .includes(line_items: [:food])
                .all
                .order(created_at: :desc)
            )
        end

        def show; end

        def update
          return render :show if @order.update(order_params)

          render_attributes_errors(@order.errors)
        end

        private

        def order_params
          params.require(:order).permit(:status)
        end

        def set_order
          @order = Order.find_by_hashid!(params[:id])
        end
      end
    end
  end
end
