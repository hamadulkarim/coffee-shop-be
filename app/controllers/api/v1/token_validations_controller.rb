module Api
  module V1
    class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
      include ActAsApiRequest
      include ExceptionHandler

      def render_validate_token_error
        render_errors(I18n.t('errors.authentication.invalid_token'), :forbidden)
      end

      def render_validate_token_success
        render :validate
      end
    end
  end
end
