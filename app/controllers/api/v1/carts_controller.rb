module Api
  module V1
    class CartsController < ApiController
      # TODO: where is the index action?
      before_action :authorize_cart

      def display; end

      def empty
        current_cart.line_items.destroy_all

        render :display
      end

      # TODO: doesn't confine with the rails conventions

      # TODO: why do we have a functionality to destroy a cart?

      private

      def authorize_cart
        authorize current_cart
      end
    end
  end
end
