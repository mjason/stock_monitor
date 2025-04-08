# frozen_string_literal: true

class StrategyVm
  # @param [StockStrategy] strategy
  def initialize(strategy)
    @strategy = strategy
    @qmt_client = QmtClient.new
  end

  # 购买当前股票
  # @param [Float] price 购买价格
  # @param [Integer] volume 购买数量
  # @return [Integer] 订单编号
  def buy(price: nil, volume: nil)
    price ||= @strategy.latest_price
    volume ||= 100
    @qmt_client.buy(@strategy.stock_symbol, volume, price)
  end

  # 卖出当前股票
  # @param [Float] price 卖出价格
  # @param [Integer] volume 卖出数量
  # @return [Integer] 订单编号
  def snell(price: nil, volume: nil)
    price ||= @strategy.latest_price
    volume ||= 100
    @qmt_client.snell(@strategy.stock_symbol, volume, price)
  end

  # 获取当前股票的订单信息
  # @return [Array<QmtModel::OrderSummary>] 当前股票已经提交的订单信息
  def orders
    @qmt_client.stock_orders.filter { it.security_code == @strategy.security_code }
  end

  # 获取当前股票的买入订单信息
  # @return [Array<QmtModel::OrderSummary>] 当前股票已经提交的订单信息
  def buy_in_transitions
    orders.buy_orders.select do |order|
      order.order_status_desc =~ /已报|待报|未报/
    end
  end

  # 获取当前股票的持仓信息
  # @return [QmtModel::Position] 当前持仓信息
  def position
    @qmt_client.positions.find { |position| position.security_code == @strategy.security_code }
  end

end
