module Api
  module V1
    class OrdersController < ApiController
      before_action :authorize_order, only: %i[index create]
      before_action :set_order, only: :show

      def index
        @pagy, @orders =
          pagy(
            current_user
              .orders
              .includes(line_items: [:food])
              .order(created_at: :desc)
          )
      end

      def show; end

      def create
        ActiveRecord::Base.transaction do
          @order = current_user.orders.create!(line_items: current_cart.line_items)

          current_cart.line_items.update_all(cart_id: nil)
        rescue ActiveRecord::RecordInvalid => e
          return render_attributes_errors(e)
        end

        render :show
      end

      private

      def authorize_order
        authorize :order
      end

      def set_order
        @order = Order.find_by_hashid!(params[:id])
        authorize @order
      end
    end
  end
end
