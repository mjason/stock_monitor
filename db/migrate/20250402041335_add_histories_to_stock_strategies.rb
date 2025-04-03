class AddHistoriesToStockStrategies < ActiveRecord::Migration[8.0]
  def change
    add_column :stock_strategies, :histories, :json, default: []
  end
end
