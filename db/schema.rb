# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_12_30_204322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.float "discount_rate", default: 0.0, null: false
    t.bigint "combination_food_id", null: false
    t.bigint "discounted_food_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["combination_food_id"], name: "index_discounts_on_combination_food_id"
    t.index ["discounted_food_id"], name: "index_discounts_on_discounted_food_id"
  end

  create_table "foods", force: :cascade do |t|
    t.float "price", default: 0.0, null: false
    t.float "tax_rate", default: 0.0, null: false
    t.integer "category", default: 0, null: false
    t.integer "prep_mins", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "description", default: "", null: false
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "quantity", default: 1, null: false
    t.bigint "cart_id"
    t.bigint "food_id", null: false
    t.bigint "order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["food_id"], name: "index_line_items_on_food_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.boolean "must_change_password", default: false
    t.string "provider", default: "email", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0
    t.json "tokens", default: {}, null: false
    t.string "uid", null: false
    t.string "unconfirmed_email"
    t.integer "role", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "carts", "users"
  add_foreign_key "discounts", "foods", column: "combination_food_id"
  add_foreign_key "discounts", "foods", column: "discounted_food_id"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "foods"
  add_foreign_key "line_items", "orders"
  add_foreign_key "orders", "users"
end
