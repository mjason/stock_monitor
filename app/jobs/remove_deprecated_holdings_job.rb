class RemoveDeprecatedHoldingsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # StockPosition.remove_deprecated_holdings!
  end
end
