module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      # TODO: order include statements
      include ActAsApiRequest
      include DeviseTokenAuth::Concerns::SetUserByToken
      include ExceptionHandler

      before_action :authenticate_user!, only: :destroy

      private

      # TODO: order methods here as well

      def render_create_error_bad_credentials
        render_errors(I18n.t('errors.authentication.invalid_credentials'), :forbidden)
      end

      def render_create_success
        render(:create)
      end

      def render_destroy_success
        head(:no_content)
      end

      def resource_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
