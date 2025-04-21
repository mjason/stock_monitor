class GetStockLatestPriceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # client = QmtClient.new
    #
    # # 1. 获取所有策略
    # strategies = StockStrategy.where(active: true)
    # # 2. 获取实时数据
    # stock_data = client.get_full_tick(strategies.map(&:stock_symbol))
    # # 3. 更新策略的实时数据
    # strategies.each do |strategy|
    #   strategy.add_price(stock_data[strategy.stock_symbol.upcase])
    # end
    #
    # # 运行策略
    # strategies.each do |strategy|
    #   strategy.run_strategy
    # end
  end
end
