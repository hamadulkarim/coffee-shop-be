module Api
  module V1
    module Shopkeeper
      # TODO: moving shopkeeper inside shopkeeper namespace
      # TODO: you can change Api::V1::ShopkeeperController -> ShopkeeperController
      class DiscountsController < BaseController
        before_action :set_discount, only: %i[show update destroy]

        def index
          @pagy, @discounts =
            pagy(
              Discount
                .includes(:discounted_food, :combination_food)
                .all
            )
          # TODO: why do we need this?
        end

        def show; end

        def create
          @discount = Discount.new(discount_params)
          # TODO: can a user another shopkeeper can access this?

          render :show and return if @discount.save

          render_attributes_errors(@discount.errors)
        end

        def update
          # REVIEW:
          render :show and return if @discount.update(discount_params)

          render_attributes_errors(@discount.errors)
        end

        # REVIEW:
        def destroy
          @discount.destroy

          render :show, status: :no_content
        end

        private

        def discount_params
          # REVIEW
          params
            .require(:discount)
            .permit(:discount_rate, :discounted_food_id, :combination_food_id)
        end

        def set_discount
          @discount = Discount.find_by_hashid!(params[:id])
        end
      end
    end
  end
end
