# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  # TODO: attribute reader use is already defined in the base class

  # TODO: we are inheriting from class but not calling superclass method
  # TODO: the only difference here is cart
  # TODO: so can we use a alias instead of overriding constructor

  alias order record

  def show?
    user.shopkeeper? || user == order.user
  end

  def create?
    user.customer?
  end
end
