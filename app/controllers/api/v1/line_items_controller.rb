module Api
  module V1
    class LineItemsController < ApiController
      before_action :authorize_line_item
      before_action :set_line_item, only: %i[show destroy increment decrement]

      def show; end

      def create
        @line_item = current_cart.line_items.new(line_item_params)

        return render :show if @line_item.save

        render_attributes_errors(@line_item.errors)
      end

      def destroy
        @line_item.destroy

        head :no_content
      end

      def increment
        @line_item.quantity += 1
        return render :show if @line_item.save

        render_attributes_errors(@line_item.errors)
      end

      def decrement
        @line_item.quantity -= 1

        return render :show if @line_item.save

        render_attributes_errors(@line_item.errors)
      end

      private

      def authorize_line_item
        authorize :line_item
      end

      def line_item_params
        params
          .require(:line_item)
          .permit(:quantity, :food_id)
          .tap do |permitted_params|
            permitted_params[:food_id] = Food.decode_id(permitted_params[:food_id])
          end
      end

      def set_line_item
        @line_item = current_cart.line_items.find_by_hashid!(params[:id])
      end
    end
  end
end
