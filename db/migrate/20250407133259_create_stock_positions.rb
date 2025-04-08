class CreateStockPositions < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_positions do |t|
      t.integer :account_type
      t.string :account_number
      t.string :stock_code
      t.integer :holding_quantity
      t.integer :available_quantity
      t.decimal :opening_price
      t.decimal :market_value
      t.integer :frozen_quantity
      t.integer :shares_in_transit
      t.integer :yesterday_shares
      t.decimal :cost_price
      t.decimal :last_price

      t.belongs_to :user
      t.string :stock_name
      t.string :act_name
      t.string :industry

      t.timestamps
    end
  end
end
