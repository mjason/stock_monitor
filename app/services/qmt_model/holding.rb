# frozen_string_literal: true

module QmtModel
  class Holding < Base
    # 证券持仓信息类
    # 表示一个证券账户的持仓情况，包括证券代码、持仓数量、盈亏情况等。

    # @!attribute [r] account_type
    #   @return [Integer] 账号类型，例如 1: 个人, 2: 机构
    attr_reader :account_type

    # @!attribute [r] funds_account
    #   @return [String] 资金账号，用户的唯一资金账户标识
    attr_reader :funds_account

    # @!attribute [r] security_code
    #   @return [String] 证券代码，例如 "000725.SZ"
    attr_reader :security_code

    # @!attribute [r] holding_quantity
    #   @return [Integer] 持仓数量，当前持有的股票数量
    attr_reader :holding_quantity

    # @!attribute [r] available_quantity
    #   @return [Integer] 可用数量，可用于交易的股票数量
    attr_reader :available_quantity

    # @!attribute [r] opening_price
    #   @return [Float] 开仓价，购买时的单价
    attr_reader :opening_price

    # @!attribute [r] market_value
    #   @return [Float] 市值，当前持仓的市场总价值
    attr_reader :market_value

    # @!attribute [r] frozen_quantity
    #   @return [Integer] 冻结数量，被锁定不可交易的股票数量
    attr_reader :frozen_quantity

    # @!attribute [r] in_transit_shares
    #   @return [Integer] 在途股份，尚未到账的股票数量
    attr_reader :in_transit_shares

    # @!attribute [r] yesterday_holding
    #   @return [Integer] 昨夜拥股，昨夜收盘时的持仓数量
    attr_reader :yesterday_holding

    # @!attribute [r] cost_price
    #   @return [Float] 成本价，持仓股票的平均买入价格
    attr_reader :cost_price

    # @!attribute [r] profit_loss
    #   @return [Float] 盈亏，当前持仓的浮动盈亏金额
    attr_reader :profit_loss

    # @!attribute [r] profit_loss_ratio
    #   @return [Float] 盈亏比例，当前持仓的浮动盈亏比例
    attr_reader :profit_loss_ratio

    # @!attribute [r] last_price
    #   @return [Float] 最新价格，当前股票的最新交易价格
    attr_reader :last_price

    def initialize(account_type:, funds_account:, security_code:, holding_quantity:,
                   available_quantity:, opening_price:, market_value:, frozen_quantity:,
                   in_transit_shares:, yesterday_holding:, cost_price:, profit_loss:, profit_loss_ratio:, last_price:)
      @account_type = account_type
      @funds_account = funds_account
      @security_code = security_code
      @holding_quantity = holding_quantity
      @available_quantity = available_quantity
      @opening_price = opening_price
      @market_value = market_value
      @frozen_quantity = frozen_quantity
      @in_transit_shares = in_transit_shares
      @yesterday_holding = yesterday_holding
      @cost_price = cost_price
      @profit_loss = profit_loss
      @profit_loss_ratio = profit_loss_ratio
      @last_price = last_price
    end

    def self.from_api_response(response)
      response.map do |holding|
        new(
          account_type: holding["账号类型"].to_i,
          funds_account: holding["资金账号"].to_s,
          security_code: holding["证券代码"].to_s,
          holding_quantity: holding["持仓数量"].to_i,
          available_quantity: holding["可用数量"].to_i,
          opening_price: holding["开仓价"].to_f,
          market_value: holding["市值"].to_f,
          frozen_quantity: holding["冻结数量"].to_i,
          in_transit_shares: holding["在途股份"].to_i,
          yesterday_holding: holding["昨夜拥股"].to_i,
          cost_price: holding["成本价"].to_f,
          profit_loss: holding["盈亏"].to_f,
          profit_loss_ratio: holding["盈亏比例"].to_f,
          last_price: holding["最新价格"].to_f,
        )
      end
    end

    def to_h
      {
        account_type: @account_type,
        funds_account: @funds_account,
        security_code: @security_code,
        holding_quantity: @holding_quantity,
        available_quantity: @available_quantity,
        opening_price: @opening_price,
        market_value: @market_value,
        frozen_quantity: @frozen_quantity,
        in_transit_shares: @in_transit_shares,
        yesterday_holding: @yesterday_holding,
        cost_price: @cost_price,
        profit_loss: @profit_loss,
        profit_loss_ratio: @profit_loss_ratio,
        last_price: @last_price,
      }
    end

    def to_json(*args)
      to_h.to_json
    end
  end
end
