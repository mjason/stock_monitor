# frozen_string_literal: true

class StrategyVm
  # @param [StockStrategy] strategy
  def initialize(strategy)
    @strategy = strategy
    @qmt_client = QmtClient.new
  end

  def puts(message)
    @strategy.logs << message
  end

  # 记录日志
  def log(message)
    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    formatted_message = "[#{timestamp}] #{message}"

    max_logs = 100

    # 使用 shift 和 push 实现固定大小的队列
    @strategy.logs.shift if @strategy.logs.size >= max_logs
    @strategy.logs.push(formatted_message)
  end

  def run
    instance_eval @strategy.code
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
    orders.select do |order|
      order.order_status_desc =~ /已报|待报|未报/ and order.order_type == 23
    end
  end

  # 获取当前卖出的订单信息
  # @return [Array<QmtModel::OrderSummary>]
  def snell_in_transitions
    orders.select do |order|
      order.order_status_desc =~ /已报|待报|未报/ and order.order_type == 24
    end
  end

  # 获取当前股票的持仓信息
  # @return [StockPosition, NilClass] 当前持仓信息
  def position
    @strategy.stock_position
  end

  # 获取当前最新的价格
  # @return [Float]
  def latest_price
    @strategy.latest_price
  end

  # 清仓策略
  # @param [Float] profit_target
  def clear_strategy(profit_target)
    if position&.profit_loss and
      position&.profit_loss >= profit_target and
      snell_in_transitions.blank?
      log "#{@strategy.name} 触发平仓规则，挂单卖出，挂单价 #{latest_price}"
      snell(price: profit_target, volume: position&.available_quantity)
    else
      log "#{@strategy.name} 未触发平仓规则，最新价格为 #{latest_price}, 盈利 #{position&.profit_loss}"
    end
  end

  # 发送通知
  def notify(message)
    Notification.new.send(
      title: "#{@strategy.name} 通知 - #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}",
      desp: message,
      tags: "#{@strategy.name}|策略通知",)
  end

end
