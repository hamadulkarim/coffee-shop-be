class ApplicationController < ActionController::Base
  # REVIEW: why are we doing this?
  protect_from_forgery prepend: true, with: :exception, unless: -> { request.format.json? }
end
