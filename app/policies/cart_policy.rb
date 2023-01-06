# frozen_string_literal: true

class CartPolicy < ApplicationPolicy
  def display?
    user.customer?
  end

  alias empty? display?
end
