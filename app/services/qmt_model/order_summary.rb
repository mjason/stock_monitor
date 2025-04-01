# frozen_string_literal: true

module QmtModel
  class OrderSummary
    # 证券委托单数据类
    # 解析并存储证券委托单的交易信息，包括订单编号、证券代码、委托价格等。

    # @!attribute [r] account_type
    #   @return [Integer] 账号类型，例如 1: 个人, 2: 机构
    attr_reader :account_type

    # @!attribute [r] funds_account
    #   @return [String] 资金账号
    attr_reader :funds_account

    # @!attribute [r] security_code
    #   @return [String] 证券代码，例如 "123219.SZ"
    attr_reader :security_code

    # @!attribute [r] order_id
    #   @return [Integer] 订单编号
    attr_reader :order_id

    # @!attribute [r] contract_id
    #   @return [String] 柜台合同编号
    attr_reader :contract_id

    # @!attribute [r] order_time
    #   @return [Time] 报单时间
    attr_reader :order_time

    # @!attribute [r] order_type
    #   @return [Integer] 委托类型，例如 23: 买入, 24: 卖出
    attr_reader :order_type

    # @!attribute [r] order_quantity
    #   @return [Integer] 委托数量
    attr_reader :order_quantity

    # @!attribute [r] quote_type
    #   @return [Integer] 报价类型
    attr_reader :quote_type

    # @!attribute [r] order_price
    #   @return [Float] 委托价格
    attr_reader :order_price

    # @!attribute [r] filled_quantity
    #   @return [Integer] 成交数量
    attr_reader :filled_quantity

    # @!attribute [r] average_price
    #   @return [Float] 成交均价
    attr_reader :average_price

    # @!attribute [r] order_status_desc
    #   @return [String] 委托状态描述，例如 "已撤", "已报"
    attr_reader :order_status_desc

    # 创建一个新的证券委托单对象
    # @param data [Hash] 委托单数据，包括订单编号、证券代码、委托价格等
    def initialize(data)
      @account_type = data["账号类型"].to_i
      @funds_account = data["资金账号"]
      @security_code = data["证券代码"]
      @order_id = data["order_id"].to_i
      @contract_id = data["柜台合同编号"]
      @order_time = Time.at(data["报单时间"].to_i)
      @order_type = data["委托类型"].to_i
      @order_quantity = data["委托数量"].to_i
      @quote_type = data["报价类型"].to_i
      @order_price = data["委托价格"].to_f
      @filled_quantity = data["成交数量"].to_i
      @average_price = data["成交均价"].to_f
      @order_status_desc = data["委托状态描述"]
    end

    # 从 API 响应中解析证券委托单数据
    # @param response [Array<Hash>] API 返回的证券委托单数据数组
    # @return [Array<OrderSummary>] 解析后的证券委托单对象数组
    def self.from_api_response(response)
      response.map { |data| new(data) }
    end

    # 转换为哈希格式
    # @return [Hash] 证券委托单数据的哈希格式
    def to_h
      {
        account_type: @account_type,
        funds_account: @funds_account,
        security_code: @security_code,
        order_id: @order_id,
        contract_id: @contract_id,
        order_time: @order_time,
        order_type: @order_type,
        order_quantity: @order_quantity,
        quote_type: @quote_type,
        order_price: @order_price,
        filled_quantity: @filled_quantity,
        average_price: @average_price,
        order_status_desc: @order_status_desc
      }
    end

    # 转换为 JSON 格式
    # @return [String] 证券委托单数据的 JSON 格式
    def to_json(*args)
      to_h.to_json
    end
  end

end
