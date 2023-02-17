class CreateFoods < ActiveRecord::Migration[6.1]
  def change
    create_table :foods do |t|
      t.float :price, null: false, default: 0.0
      t.float :tax_rate, null: false, default: 0.0
      t.integer :category, null: false, default: 0
      t.integer :prep_mins, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.string :description, null: false, default: ''
      t.string :name, null: false, default: ''

      t.timestamps
    end
  end
end
