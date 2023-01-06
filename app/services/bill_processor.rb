class BillProcessor < ApplicationService
  def initialize(line_items)
    @line_items = line_items
  end

  def call
    sub_total
    total_bill
    total_prep_time
    total_discount
  end

  def sub_total
    @sub_total ||=
      # TODO: can we have a separate method for total bill without discount -> sub_total?
      # TODO: why can't we direct use sum?
      @line_items.sum do |line_item|
        taxed_prices_by_food.fetch(line_item.food_id) * line_item.quantity
      end
  end

  def total_bill
    @total_bill ||= sub_total - total_discount
  end

  def total_discount
    # TODO: why can't we direct use sum?
    @total_discount ||= available_discounts.sum(&:amount_discounted)
  end

  def total_prep_time
    @total_prep_time ||=
      # TODO: can we use any accumulation method here?
      # HINT: reduce or inject
      # TODO: why can't we direct use sum?
      @line_items.sum do |line_item|
        prep_time_by_food.fetch(line_item.food_id) * line_item.quantity
      end
  end

  private

  # TODO: can we break this into multiple methods?
  def available_discounts
    @available_discounts ||=
      possible_discounts.reject do |discount|
        discount.discounted_food_id == discount.combination_food_id && items_by_food_id.fetch(discount.discounted_food_id) > 1
      end
  end

  def food_ids
    @food_ids ||= @line_items.pluck(:food_id).uniq
  end

  def items_by_food_id
    @items_by_food_id ||= @line_items.to_h { |item| [item.food_id, item.quantity] }
  end

  def ordered_foods
    @ordered_foods ||= Food.where(id: food_ids)
  end

  def possible_discounts
    @possible_discounts = Discount.where(discounted_food_id: food_ids,
                                         combination_food_id: food_ids)
  end

  def prep_time_by_food
    @prep_time_by_food ||=
      ordered_foods.to_h do |food|
        [food.id, food.prep_mins]
      end
  end

  def taxed_prices_by_food
    @taxed_prices_by_food ||=
      ordered_foods.to_h do |food|
        [food.id, food.taxed_price]
      end
  end
end
