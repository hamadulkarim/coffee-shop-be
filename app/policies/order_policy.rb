# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  alias order record

  def index?
    true
  end

  def show?
    user.shopkeeper? || user == order.user
  end

  def create?
    user.customer?
  end
end
