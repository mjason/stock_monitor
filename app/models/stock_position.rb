class StockPosition < ApplicationRecord
  belongs_to :user, optional: true
  has_one :stock_strategy

  after_update_commit do
    broadcast_replace_to "stock_positions_index",
                         target:  ActionView::RecordIdentifier.dom_id(self),
                         partial: "root/stock_position_tr",
                         locals: { position: self }
  end

  def buy_cost_total
    (cost_price * holding_quantity)
  end

  def profit_loss
    market_value -
      buy_cost_total -
      AStockTradingCost.new.sell_cost_for_code(stock_code, market_value)[:total_fee]
  end

  def profit_loss_ratio
    return 0 if buy_cost_total == 0
    profit_loss / buy_cost_total * 100
  end

end
