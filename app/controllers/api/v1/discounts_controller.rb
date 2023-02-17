module Api
  module V1
    class DiscountsController < ApiController
      before_action :set_discount, only: :show
      skip_before_action :authenticate_user!, only: %i[index show]

      def index
        @pagy, @discounts =
          pagy(
            Discount
              .includes(:discounted_food, :combination_food)
              .all
          )
      end

      def show; end

      private

      def set_discount
        @discount = Discount.find_by_hashid!(params[:id])
      end
    end
  end
end
