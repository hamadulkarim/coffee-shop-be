module Api
  module V1
    module Shopkeeper
      class DiscountsController < BaseController
        before_action :set_discount, only: %i[show update destroy]

        def index
          @pagy, @discounts =
            pagy(
              Discount
                .includes(:discounted_food, :combination_food)
                .all
            )
        end

        def show; end

        def create
          @discount = Discount.new(discount_params)

          return render :show if @discount.save

          render_attributes_errors(@discount.errors)
        end

        def update
          return render :show if @discount.update(discount_params)

          render_attributes_errors(@discount.errors)
        end

        def destroy
          @discount.destroy

          head :no_content
        end

        private

        def discount_params
          params
            .require(:discount)
            .permit(:discount_rate, :discounted_food_id, :combination_food_id)
            .tap do |permitted_params|
              permitted_params[:combination_food_id] =
                Food.decode_id(permitted_params[:combination_food_id])
              permitted_params[:discounted_food_id] =
                Food.decode_id(permitted_params[:discounted_food_id])
            end
        end

        def set_discount
          @discount = Discount.find_by_hashid!(params[:id])
        end
      end
    end
  end
end
