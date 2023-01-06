module Api
  module V1
    module Shopkeeper
      # TODO: moving shopkeeper inside shopkeeper namespace
      # TODO: you can change Api::V1::ShopkeeperController -> ShopkeeperController
      class FoodsController < BaseController
        before_action :set_food, only: %i[show update destroy]

        def index
          @pagy, @foods = pagy(Food.all.order(:name))
          # TODO: why do we need this?
        end

        def show; end

        def create
          @food = Food.new(food_params)
          # REVIEW: alternate method
          render :show and return if @food.save

          render_attributes_errors(@food.errors)
        end

        def update
          # REVIEW: alternate method
          render :show and return if @food.update(food_params)

          render_attributes_errors(@food.errors)
        end

        def destroy
          # REVIEW: early return
          # TODO: no need to create a separate method
          @food.destroy

          render :show, status: :no_content
        end

        private

        def food_params
          params
            .require(:food)
            .permit(:name, :description, :price, :tax_rate, :status, :prep_mins, :category)
        end

        def set_food
          @food = Food.find_by_hashid!(params[:id])
        end
      end
    end
  end
end
