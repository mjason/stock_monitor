class FetchStockHistoriesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    StockDailyPrice.sync StockStrategy.where(active: true).map(&:stock_symbol)
  end
end
