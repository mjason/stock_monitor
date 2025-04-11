class CreateStockStrategies < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_strategies do |t|
      t.string :name, null: false
      t.string :ts_code, null: false
      t.text :code
      t.json :prices, default: []
      t.boolean :active, default: true
      t.json :logs, default: []

      t.belongs_to :user, index: true
      t.belongs_to :stock_position, index: true

      t.timestamps
    end

    add_index :stock_strategies, :name
    add_index :stock_strategies, :ts_code
  end
end
