require 'rails_helper'

describe BillProcessor, type: :service do
  let(:line_items) { create_list(:line_item, 2) }
  let(:bill_processor) { described_class.call(line_items) }

  describe '#sub_total' do
    specify do
      sub_total =
        line_items.sum do |line_item|
          line_item.food.taxed_price * line_item.quantity
        end
      expect(bill_processor.sub_total).to equal(sub_total)
    end
  end

  describe '#total_prep_time' do
    specify do
      total_prep_time =
        line_items.sum do |line_item|
          line_item.food.prep_mins * line_item.quantity
        end

      expect(bill_processor.total_prep_time).to equal(total_prep_time)
    end
  end
end
