require 'rails_helper'

describe BillProcessor, type: :service do
  let(:combination_food) { create(:food, price: 5.5, tax_rate: 40, prep_mins: 3) }
  let(:discounted_food) { create(:food, price: 33, tax_rate: 15, prep_mins: 5) }

  let!(:discount) do
    create(:discount, discounted_food: discounted_food, combination_food: combination_food,
                      discount_rate: 11)
  end

  let(:combination_line_item) { create(:line_item, food: combination_food, quantity: 1) }
  let(:discounted_line_item)  { create(:line_item, food: discounted_food, quantity: 1) }

  let(:line_items) { [combination_line_item, discounted_line_item] }
  let(:bill_processor) { described_class.call(line_items) }

  describe '#sub_total' do
    it do
      expect(bill_processor.sub_total).to equal(45.65)
    end
  end

  describe '#total_bill' do
    it do
      expect(bill_processor.total_bill).to equal(42.02)
    end
  end

  describe '#total_discount' do
    it do
      expect(bill_processor.total_discount).to equal(3.63)
    end
  end

  describe '#total_prep_time' do
    it do
      expect(bill_processor.total_prep_time).to equal(8)
    end
  end
end
