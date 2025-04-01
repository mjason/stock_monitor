# frozen_string_literal: true

module QmtModel
  class Account < Base

    # 账户信息类
    # 表示用户的资金账户信息，包括账户类型、可用金额、总资产等。

    # @!attribute [r] account_type
    #   @return [Integer] 账号类型，例如 1: 个人, 2: 机构
    attr_reader :account_type

    # @!attribute [r] funds_account
    #   @return [String] 资金账号，用户的唯一资金账户标识
    attr_reader :funds_account

    # @!attribute [r] available_balance
    #   @return [Float] 可用金额，当前账户可用的余额
    attr_reader :available_balance

    # @!attribute [r] frozen_balance
    #   @return [Float] 冻结金额，暂时不可用的资金
    attr_reader :frozen_balance

    # @!attribute [r] market_value
    #   @return [Float] 持仓市值，当前持仓的市场总价值
    attr_reader :market_value

    # @!attribute [r] total_assets
    #   @return [Float] 总资产，账户的整体资产总额
    attr_reader :total_assets

    def initialize(account_type:, funds_account:, available_balance:, frozen_balance:, market_value:, total_assets:)
      @account_type = account_type
      @funds_account = funds_account
      @available_balance = available_balance
      @frozen_balance = frozen_balance
      @market_value = market_value
      @total_assets = total_assets
    end

    def self.from_api_response(response)
      new(
        account_type: response["账号类型"].to_i,
        funds_account: response["资金账号"].to_s,
        available_balance: response["可用金额"].to_f,
        frozen_balance: response["冻结金额"].to_f,
        market_value: response["持仓市值"].to_f,
        total_assets: response["总资产"].to_f
      )
    end

    def to_h
      {
        account_type: @account_type,
        funds_account: @funds_account,
        available_balance: @available_balance,
        frozen_balance: @frozen_balance,
        market_value: @market_value,
        total_assets: @total_assets
      }
    end

    def to_json(*args)
      to_h.to_json
    end

  end
end
