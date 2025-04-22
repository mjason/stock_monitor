class StockPosition < ApplicationRecord
  belongs_to :user, optional: true
  has_one :stock_strategy

  alias_attribute :stock_code, :ts_code

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

  class << self
    # 清理过期的持仓记录
    def remove_deprecated_holdings!(positions)
      # 获取券商接口的真实持仓代码
      current_codes = positions.map(&:security_code)

      # 找出本地需要清理的持仓代码（存在于本地但不在券商接口返回列表中的）
      local_codes = pluck(:ts_code)
      deprecated_codes = local_codes - current_codes

      # 清理过期持仓
      where(ts_code: deprecated_codes).destroy_all if deprecated_codes.any?
    end
  end

end
