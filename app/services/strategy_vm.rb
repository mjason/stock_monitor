# frozen_string_literal: true

class StrategyVm
  # @param [StockStrategy] strategy
  def initialize(strategy)
    @strategy = strategy
    @qmt_client = QmtClient.new
  end

  def buy(price: nil, volume: nil)
    price ||= @strategy.latest_price
    volume ||= 100
    @qmt_client.buy(@strategy.stock_symbol, volume, price)
  end

  def snell(price: nil, volume: nil)
    price ||= @strategy.latest_price
    volume ||= 100
    @qmt_client.snell(@strategy.stock_symbol, volume, price)
  end

  def orders
    @qmt_client.stock_orders.filter { it.security_code == @strategy.security_code }
  end

  def buy_in_transitions
    orders.buy_orders.select do |order|
      order.order_status_desc =~ /已报|待报|未报/
    end
  end

  def position
    @qmt_client.positions.find { |position| position.security_code == @strategy.security_code }
  end

end
