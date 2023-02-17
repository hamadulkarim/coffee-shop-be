# frozen_string_literal: true

class LineItemPolicy < ApplicationPolicy
  def create?
    user.customer?
  end

  alias show? create?
  alias destroy? create?
  alias increment? create?
  alias decrement? create?
end
