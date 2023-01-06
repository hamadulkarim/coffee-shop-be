module Api
  module V1
    class UsersController < ApiController
      helper_method :user

      before_action :require_check_if_changing_password, only: :update

      def show; end

      def update
        user.update!(user_params)
      end

      private

      # TODO: order methods

      def require_check_if_changing_password
        return if !user_params[:password] || user.valid_password?(params[:password_check])

        render_errors(I18n.t('errors.authentication.invalid_password_check'), :bad_request)
      end

      def user
        @user ||= current_user
      end

      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end
    end
  end
end
