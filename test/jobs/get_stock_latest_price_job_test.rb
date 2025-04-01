require "test_helper"

class GetStockLatestPriceJobTest < ActiveJob::TestCase
  test "测试运行" do
    GetStockLatestPriceJob.perform_now
  end
  # test "the truth" do
  #   assert true
  # end
end
