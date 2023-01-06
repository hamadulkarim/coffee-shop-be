module Api
  module V1
    class ApiController < ActionController::API
      include ActAsApiRequest
      include DeviseTokenAuth::Concerns::SetUserByToken
      include ExceptionHandler
      include Pagy::Backend
      include Pundit::Authorization

      before_action :authenticate_user!

      # TODO: Do we need to make this method private?
      def current_cart
        @current_cart ||= Cart.find_or_create_by!(user: current_user)
      end

      helper_method :current_cart
    end
  end
end
