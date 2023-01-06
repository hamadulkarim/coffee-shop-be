module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      include ActAsApiRequest
      include ExceptionHandler

      private

      def render_create_error
        raise ActiveRecord::RecordInvalid, @resource
      end

      def render_create_success
        render :create
      end

      def sign_up_params
        params.require(:user).permit(:email, :password, :first_name, :last_name, :role)
      end

      def validate_post_data(which, message)
        render_errors(message, :bad_request) if which.empty?
      end
    end
  end
end
