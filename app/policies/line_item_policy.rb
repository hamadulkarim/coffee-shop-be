# frozen_string_literal: true

class LineItemPolicy < ApplicationPolicy
  # TODO: attribute reader use is already defined in the base class

  # TODO: we are inheriting from class but not calling superclass method
  # TODO: the only difference here is cart
  # TODO: so can we use a alias instead of overriding constructor

  def create?
    user.customer?
  end

  alias show? create?
  alias destroy? create?
  alias increment? create?
  alias decrement? create?
end
