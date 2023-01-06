# TODO: this file should be in shopkeeper scope
module Api
  module V1
    module Shopkeeper
      class BaseController < Api::V1::ApiController
        before_action :require_shopkeeper!

        private

        # REVIEW:
        def require_shopkeeper!
          return if current_user.shopkeeper?

          raise Pundit::NotAuthorizedError
        end
      end
    end
  end
end
