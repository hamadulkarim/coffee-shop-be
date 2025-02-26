class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    change_table :users, bulk: true do |t|
      t.datetime :confirmation_sent_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :current_sign_in_at
      t.string :current_sign_in_ip
      t.string :email, null: false
      t.string :encrypted_password, null: false, default: nil
      t.datetime :last_sign_in_at
      t.string :last_sign_in_ip
      t.boolean :must_change_password, default: false
      t.string :provider, null: false, default: 'email'
      t.datetime :remember_created_at
      t.datetime :reset_password_sent_at
      t.string :reset_password_token
      t.integer :sign_in_count, default: 0
      t.json :tokens, null: false, default: {}
      t.string :uid, null: false, default: nil
      t.string :unconfirmed_email
    end

    add_index :users, :email, unique: true, algorithm: :concurrently
    add_index :users, %i[uid provider], unique: true, algorithm: :concurrently
    add_index :users, :reset_password_token, unique: true, algorithm: :concurrently
    add_index :users, :confirmation_token, unique: true, algorithm: :concurrently
  end
end
