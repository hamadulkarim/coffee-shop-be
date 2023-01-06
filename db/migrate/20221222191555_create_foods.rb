class CreateFoods < ActiveRecord::Migration[6.1]
  def change
    create_table :foods do |t|
      # TODO: shouldn't we give a default value if we want name to be not null?
      t.string :name, null: false, default: ''
      # TODO: shouldn't we give a default value if we want description to be not null?
      t.string :description, null: false, default: ''
      # TODO: shouldn't we give a default value if we want price to be not null?
      t.float :price, null: false, default: 0.0
      # TODO: tax rate is also amount, shouldn't it be float as well
      # TODO: shouldn't we give a default value if we want tax_rate to be not null?
      t.float :tax_rate, null: false, default: 0.1
      t.integer :status, null: false, default: 0
      # TODO: shouldn't we give a default value if we want prep_mins to be not null?
      t.integer :prep_mins, null: false, default: 1
      t.integer :category, null: false, default: 0

      t.timestamps
    end
  end
end
