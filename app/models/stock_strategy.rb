class StockStrategy < ApplicationRecord
  # 枚举定义
  enum :security_type, { stock: 0, etf: 1, convertible_bond: 2 }

  # 验证
  validates :name, presence: true
  validates :stock_symbol, presence: true, uniqueness: true
  validates :security_type, presence: true

  after_update_commit do
    broadcast_replace_to "stock_strategies_index",
                          target:  ActionView::RecordIdentifier.dom_id(self),
                          partial: "stock_strategies/stock_strategy_tr",
                          locals: { stock_strategy: self }
  end

  # 日志方法 - 添加新价格到价格日志
  def add_price(price)
    current_log = price_log || []

    current_log_last_price_timestamp = current_log&.last&.fetch("timestamp", nil)

    if current_log_last_price_timestamp != price["timestamp"]
      # 保持最新的5条记录
      updated_log = (current_log + [ price ]).last(5)
      update(price_log: updated_log)
    end
  end

  def get_realtime_data
    price_log&.map do |price|
      QmtModel::RealtimeStockData.new(**price.symbolize_keys)
    end
  end

  def latest_data
    return nil if price_log.blank?
    QmtModel::RealtimeStockData.new(**price_log&.last&.symbolize_keys)
  end

  # 获取最新价格
  def latest_price
    latest_data&.last_price
  end
end
