module Api
  module V1
    module Shopkeeper
      class FoodsController < BaseController
        before_action :set_food, only: %i[show update destroy]

        def index
          @pagy, @foods = pagy(Food.all.order(:name))
        end

        def show; end

        def create
          @food = Food.new(food_params)

          return render :show if @food.save

          render_attributes_errors(@food.errors)
        end

        def update
          return render :show if @food.update(food_params)

          render_attributes_errors(@food.errors)
        end

        def destroy
          @food.destroy

          head :no_content
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
