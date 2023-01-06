class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps null: false
    end
  end
end