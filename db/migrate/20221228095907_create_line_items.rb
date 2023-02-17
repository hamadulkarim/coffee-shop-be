class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.integer :quantity, null: false, default: 1

      t.references :cart, foreign_key: true
      t.references :food, foreign_key: true, null: false
      t.references :order, foreign_key: true
      
      t.timestamps
    end
  end
end
