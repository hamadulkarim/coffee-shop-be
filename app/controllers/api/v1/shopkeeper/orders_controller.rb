module Api
  module V1
    module Shopkeeper
      # TODO: moving shopkeeper inside shopkeeper namespace
      # TODO: you can change Api::V1::ShopkeeperController -> ShopkeeperController
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
          # TODO: why do we need this?
        end

        def show; end

        def update
          # TODO: are we showing any errors if the order is not updated?
          render :show and return if @order.update(order_params)

          render_attributes_errors(@order.errors)
        end

        private

        # TODO: order methods alphabetically here

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
