module Api
  module V1
    class CartsController < ApiController
      before_action :authorize_cart

      def show; end

      def empty
        current_cart.line_items.destroy_all

        render :show
      end

      private

      def authorize_cart
        authorize current_cart
      end
    end
  end
end
