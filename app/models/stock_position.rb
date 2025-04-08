class StockPosition < ApplicationRecord
  belongs_to :user, optional: true
  has_one :stock_strategy

  after_update_commit do
    broadcast_replace_to "stock_positions_index",
                         target:  ActionView::RecordIdentifier.dom_id(self),
                         partial: "root/stock_position_tr",
                         locals: { position: self }
  end


  def profit_loss
    calculate_profit[:unrealized_profit]
  end

  def calculate_profit
    # 基础价差收益
    price_profit = (last_price - cost_price) * holding_quantity

    # 买入成本（不考虑印花税，因为买入不收）
    buy_cost = calculate_commission(cost_price * holding_quantity)
    # 过户费（仅沪市收取，这里假设是沪市股票）
    transfer_fee = calculate_transfer_fee(cost_price * holding_quantity)

    # 如果要计算卖出费用（假设全部卖出）
    sell_commission = calculate_commission(last_price * holding_quantity)
    sell_stamp_tax = calculate_stamp_tax(last_price * holding_quantity)
    sell_transfer_fee = calculate_transfer_fee(last_price * holding_quantity)

    # 未卖出时的持仓收益（不包括卖出费用）
    unrealized_profit = price_profit - buy_cost - transfer_fee

    # 如果全部卖出后的净收益
    realized_profit = unrealized_profit - sell_commission - sell_stamp_tax - sell_transfer_fee

    {
      unrealized_profit: unrealized_profit,
      realized_profit: realized_profit,
      unrealized_profit_rate: (unrealized_profit / (cost_price * holding_quantity + buy_cost + transfer_fee)) * 100,
      realized_profit_rate: (realized_profit / (cost_price * holding_quantity + buy_cost + transfer_fee)) * 100
    }
  end

  private

  # 计算佣金（万一，不免五）
  def calculate_commission(amount)
    commission = amount * 0.0001  # 万一（0.01%）
    # 如果有最低5元限制，可以添加：
    # commission = [commission, 5].max
    [ commission, 5 ].max
  end

  # 计算印花税（仅卖出收取0.1%）
  def calculate_stamp_tax(amount)
    amount * 0.001  # 0.1%
  end

  # 计算过户费（沪市股票收取成交金额的0.002%）
  def calculate_transfer_fee(amount)
    if stock_code.end_with?("SH")
      amount * 0.00002  # 0.002%
    else
      0.0
    end
  end

end
