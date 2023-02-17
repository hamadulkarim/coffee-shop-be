class CreateDiscounts < ActiveRecord::Migration[6.1]
  def change
    create_table :discounts do |t|
      t.float :discount_rate, null: false, default: 0.0

      t.references :combination_food, null: false
      t.references :discounted_food, null: false

      t.timestamps
    end
    add_foreign_key :discounts, :foods, column: :combination_food_id, primary_key: :id, validate: false
    add_foreign_key :discounts, :foods, column: :discounted_food_id, primary_key: :id, validate: false
  end
end