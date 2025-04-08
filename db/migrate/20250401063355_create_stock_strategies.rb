class CreateStockStrategies < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_strategies do |t|
      t.string :name, null: false
      t.string :stock_symbol, null: false
      t.integer :security_type, default: 0
      t.text :code
      t.json :price_log, default: []
      t.boolean :active, default: true

      t.belongs_to :user, index: true
      t.belongs_to :stock_position, index: true

      t.timestamps
    end

    add_index :stock_strategies, :name
    add_index :stock_strategies, :stock_symbol
  end
end
