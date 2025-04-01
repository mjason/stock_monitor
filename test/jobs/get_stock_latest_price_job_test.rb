require "test_helper"

class GetStockLatestPriceJobTest < ActiveJob::TestCase
  test "测试运行" do
    GetStockLatestPriceJob.perform_now
    stock_strategies = StockStrategy.where(active: true)
    assert_not stock_strategies.first.latest_price.blank?
  end

  test "在非交易时间运行不要改变最新价格" do
    if Time.now.hour > 15
      GetStockLatestPriceJob.perform_now
      GetStockLatestPriceJob.perform_now

      stock_strategies = StockStrategy.where(active: true)
      assert_equal stock_strategies.first.price_log.size, 1
    end
  end
end
