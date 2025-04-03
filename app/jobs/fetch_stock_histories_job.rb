class FetchStockHistoriesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = QmtClient.new

    strategies = StockStrategy.where(active: true, security_type: :stock)
    codes = strategies.map(&:stock_symbol)

    histories = client.get_history_data(codes)

    strategies.each do |strategy|
      # 获取策略对应的历史数据
      strategy_histories = histories[strategy.stock_symbol.upcase]

      # 处理历史数据
      if strategy_histories.present?
        # 更新策略的历史数据
        strategy.update(histories: strategy_histories)
      end
    end

  end
end
