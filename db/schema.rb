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

ActiveRecord::Schema[8.0].define(version: 2025_04_08_152823) do
  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "stock_daily_prices", force: :cascade do |t|
    t.string "ts_code", null: false
    t.string "trade_date", null: false
    t.float "open"
    t.float "high"
    t.float "low"
    t.float "close"
    t.float "pre_close"
    t.float "change"
    t.float "pct_chg"
    t.float "vol"
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trade_date"], name: "index_stock_daily_prices_on_trade_date"
    t.index ["ts_code", "trade_date"], name: "index_stock_daily_prices_on_ts_code_and_trade_date", unique: true
  end

  create_table "stock_positions", force: :cascade do |t|
    t.integer "account_type"
    t.string "account_number"
    t.string "ts_code"
    t.integer "holding_quantity"
    t.integer "available_quantity"
    t.decimal "opening_price"
    t.decimal "market_value"
    t.integer "frozen_quantity"
    t.integer "shares_in_transit"
    t.integer "yesterday_shares"
    t.decimal "cost_price"
    t.decimal "last_price"
    t.integer "user_id"
    t.string "stock_name"
    t.string "act_name"
    t.string "industry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stock_positions_on_user_id"
  end

  create_table "stock_strategies", force: :cascade do |t|
    t.string "name", null: false
    t.string "ts_code", null: false
    t.text "code"
    t.json "prices", default: []
    t.boolean "active", default: true
    t.json "logs", default: []
    t.integer "user_id"
    t.integer "stock_position_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stock_strategies_on_name"
    t.index ["stock_position_id"], name: "index_stock_strategies_on_stock_position_id"
    t.index ["ts_code"], name: "index_stock_strategies_on_ts_code"
    t.index ["user_id"], name: "index_stock_strategies_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
end
