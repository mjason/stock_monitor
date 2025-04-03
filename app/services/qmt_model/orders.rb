# frozen_string_literal: true

module Qmt
  class Orders < Base
    # @!attribute [Qmt::OrderSummary] order_summaries 订单列表
    def initialize(order_summaries)
      @order_summaries = order_summaries
    end

    # @return [Array<Qmt::OrderSummary>] 买入订单列表
    def buy_orders
      @order_summaries.select { |order| order.order_type == 23 }
    end

    # @return [Array<Qmt::OrderSummary>] 卖出订单列表
    def snell_orders
      @order_summaries.select { |order| order.order_type == 24 }
    end


  end
end
