class BillProcessor < ApplicationService
  attr_reader :line_items

  def initialize(line_items)
    @line_items = line_items
  end

  def sub_total
    @sub_total ||=
      line_items.sum { |line_item|
        taxed_prices_by_food.fetch(line_item.food_id) * line_item.quantity
      }.round(3)
  end

  def total_bill
    @total_bill ||= (sub_total - total_discount).round(3)
  end

  def total_discount
    @total_discount ||= available_discounts.sum(&:amount_discounted).round(3)
  end

  def total_prep_time
    @total_prep_time ||=
      line_items.sum do |line_item|
        prep_time_by_food.fetch(line_item.food_id) * line_item.quantity
      end
  end

  private

  def available_discounts
    @available_discounts ||=
      possible_discounts.reject do |discount|
        discount.discounted_food_id == discount.combination_food_id &&
          items_by_food_id.fetch(discount.discounted_food_id) > 1
      end
  end

  def food_ids
    @food_ids ||= line_items.pluck(:food_id).uniq
  end

  def items_by_food_id
    @items_by_food_id ||= line_items.to_h { |item| [item.food_id, item.quantity] }
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
