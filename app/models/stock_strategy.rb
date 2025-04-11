class StockStrategy < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :stock_position, optional: true

  alias_attribute :stock_symbol, :ts_code
  alias_attribute :price_log, :prices

  # 验证
  validates :name, presence: true
  validates :stock_symbol, presence: true, uniqueness: true

  after_update_commit do
    broadcast_replace_to "stock_strategies_index",
                          target:  ActionView::RecordIdentifier.dom_id(self),
                          partial: "stock_strategies/stock_strategy_tr",
                          locals: { stock_strategy: self }
  end

  after_create_commit do
    StockDailyPrice.sync_all stock_symbol
  end

  def run_strategy
    StrategyVm.new(self).run
    if self.changed?
      new_logs = logs - logs_was
      save.tap do
        new_logs.reverse.each do |log|
          broadcast_prepend_to "stock_strategies_show",
                               target: "strategy-logs",
                               partial: "stock_strategies/log",
                               locals: { log: log }
          end
      end
    end
  end

  def run_strategy_generator
    StrategyGenService.new(self)
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
    price_log.map do |price|
      QmtModel::RealtimeStockData.new(**price.symbolize_keys)
    end
  end

  def latest_data
    return nil if price_log.blank?
    QmtModel::RealtimeStockData.new(**price_log.last&.symbolize_keys)
  end

  # 获取最新价格
  def latest_price
    latest_data&.last_price
  end

  def stock_history_data
    StockDailyPrice.where(ts_code: stock_symbol)
                   .order(trade_date: :asc).map do |data|
      {
        time: Time.parse(data.trade_date),
        open: data.open,
        high: data.high,
        low: data.low,
        close: data.close,
        volume: data.vol
      }
    end
  end

  def ta_data
    stock_history_data&.map do |data|
      data.transform_keys { |k| k == "time" ? "date_time" : k }
    end
  end

end
