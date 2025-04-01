# frozen_string_literal: true

module QmtModel
  class ConvertibleBond
    # 可转换债券数据类
    # 解析并存储可转债的交易信息，包括价格、涨跌幅等数据。

    # @!attribute [r] symbol
    #   @return [String] 转换后的债券交易代码，例如 "110059.SH"
    def symbol
      "#{@code}.#{@symbol[0..1]&.upcase}"
    end

    # @!attribute [r] name
    #   @return [String] 债券名称，例如 "伊力转债"
    attr_reader :name

    # @!attribute [r] trade
    #   @return [Float] 最新成交价
    attr_reader :trade

    # @!attribute [r] price_change
    #   @return [Float] 价格变化
    attr_reader :price_change

    # @!attribute [r] change_percent
    #   @return [Float] 价格变动百分比
    attr_reader :change_percent

    # @!attribute [r] buy
    #   @return [Float] 买入价格
    attr_reader :buy

    # @!attribute [r] sell
    #   @return [Float] 卖出价格
    attr_reader :sell

    # @!attribute [r] settlement
    #   @return [Float] 结算价
    attr_reader :settlement

    # @!attribute [r] open
    #   @return [Float] 开盘价
    attr_reader :open

    # @!attribute [r] high
    #   @return [Float] 最高价
    attr_reader :high

    # @!attribute [r] low
    #   @return [Float] 最低价
    attr_reader :low

    # @!attribute [r] volume
    #   @return [Integer] 成交量
    attr_reader :volume

    # @!attribute [r] amount
    #   @return [Float] 成交金额
    attr_reader :amount

    # @!attribute [r] code
    #   @return [String] 债券代码，例如 "110055"
    attr_reader :code

    # @!attribute [r] tick_time
    #   @return [String] 最新成交时间，例如 "15:00:01"
    attr_reader :tick_time

    # 创建一个新的可转换债券对象
    # @param data [Hash] 债券交易数据，包括价格、成交量等信息
    def initialize(data)
      @symbol = data["symbol"]
      @name = data["name"]
      @trade = data["trade"].to_f
      @price_change = data["pricechange"].to_f
      @change_percent = data["changepercent"].to_f
      @buy = data["buy"].to_f
      @sell = data["sell"].to_f
      @settlement = data["settlement"].to_f
      @open = data["open"].to_f
      @high = data["high"].to_f
      @low = data["low"].to_f
      @volume = data["volume"].to_i
      @amount = data["amount"].to_f
      @code = data["code"]
      @tick_time = data["ticktime"]
    end

    # 从 API 响应中解析可转债数据
    # @param response [Array<Hash>] API 返回的可转换债券数据数组
    # @return [Array<ConvertibleBond>] 解析后的可转债数据对象数组
    def self.from_api_response(response)
      response.map { |data| new(data) }
    end

    # 转换为哈希格式
    # @return [Hash] 可转债数据的哈希格式
    def to_h
      {
        symbol: symbol,
        name: @name,
        trade: @trade,
        price_change: @price_change,
        change_percent: @change_percent,
        buy: @buy,
        sell: @sell,
        settlement: @settlement,
        open: @open,
        high: @high,
        low: @low,
        volume: @volume,
        amount: @amount,
        code: @code,
        tick_time: @tick_time
      }
    end

    # 转换为 JSON 格式
    # @return [String] 可转债数据的 JSON 格式
    def to_json(*args)
      to_h.to_json
    end
  end
end
