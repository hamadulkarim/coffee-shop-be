# frozen_string_literal: true

class CartPolicy < ApplicationPolicy
  def show?
    user.customer?
  end

  alias empty? show?
end
