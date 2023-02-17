module Api
  module V1
    class FoodsController < ApiController
      before_action :set_food, only: :show
      skip_before_action :authenticate_user!, only: %i[index show]

      def index
        @pagy, @foods = pagy(Food.paid.available.order(:name))
      end

      def show; end

      private

      def set_food
        @food = Food.find_by_hashid!(params[:id])
      end
    end
  end
end
