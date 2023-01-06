module Api
  module V1
    class LineItemsController < ApiController
      # TODO: do we really need to call current_method to be able to use it
      before_action :set_line_item, only: %i[show destroy increment decrement]

      def show; end

      def create
        # TODO: why are we not using hashid here?
        # TODO: Do we really need this?

        @line_item = current_cart.line_items.new(line_item_params)
        authorize @line_item

        # REVIEW: you may use early return
        render :show and return if @line_item.save

        render_attributes_errors(@line_item.errors)
      end

      def destroy
        @line_item.destroy

        render :show, status: :no_content
      end

      # TODO: check if there occurs any race conditions?
      def increment
        render :show and return if @line_item.increment!(:quantity).valid?

        render_attributes_errors(@line_item.errors)
      end

      # TODO: check if there occurs any race conditions?
      def decrement
        ActiveRecord::Base.transaction do
          @line_item.decrement!(:quantity)

          render :show and return if @line_item.valid?

          raise ActiveRecord::Rollback
        end

        render_attributes_errors(@line_item.errors)
      end

      private

      def line_item_params
        params.require(:line_item).permit(:quantity, :food_id)
      end

      def set_line_item
        @line_item = current_cart.line_items.find_by_hashid!(params[:id])
        authorize @line_item
      end
    end
  end
end
