class CreateDiscounts < ActiveRecord::Migration[6.1]
  def change
    create_table :discounts do |t|
      # TODO: shouldn't we give a default value if we want discount_rate to be not null?
      t.float :discount_rate, null: false, default: 0.1

      t.references :discounted_food, null: false
      t.references :combination_food, null: false

      t.timestamps
    end
    add_foreign_key :discounts, :foods, column: :discounted_food_id, primary_key: :id, validate: false
    add_foreign_key :discounts, :foods, column: :combination_food_id, primary_key: :id, validate: false
  end
end