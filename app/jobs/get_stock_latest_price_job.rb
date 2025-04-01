class GetStockLatestPriceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    # 1. 获取所有策略
    strategies = StockStrategy.where(active: true)
    # 2. 获取实时数据
    stock_data = QmtModel::RealtimeStockData.from_api_response(QmtModel::RealtimeStockData.get_realtime_data(strategies.map(&:stock_symbol)))
    # 3. 更新策略的实时数据
    strategies.each do |strategy|
      strategy.update(price_log: stock_data[strategy.stock_symbol].to_json)
    end
  rescue StandardError => e
    Rails.logger.error("Error in GetStockLatestPriceJob: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end
end
