# frozen_string_literal: true

module QmtModel
  class HistoricalStockData < Base
    # 历史股票数据类
    # 解析并存储某只股票的历史交易记录。

    # @!attribute [r] symbol
    #   @return [String] 股票代码，例如 "600519.SH"
    attr_reader :symbol

    # @!attribute [r] records
    #   @return [Array<HistoricalStockRecord>] 该股票的历史交易记录数组
    attr_reader :records

    # 创建一个新的历史股票数据对象
    # @param symbol [String] 股票代码
    # @param records [Array<HistoricalStockRecord>] 该股票的历史交易记录数组
    def initialize(symbol:, records:)
      @symbol = symbol
      @records = records
    end

    # 从 API 响应中解析历史股票数据
    # @param response [Hash] API 返回的历史股票数据，键为股票代码，值为包含多个历史交易记录的数组
    # @return [Hash<Symbol, HistoricalStockData>] 解析后的历史股票数据对象
    def self.from_api_response(response)
      response.map do |symbol, data_array|
        records = data_array.map { |data| HistoricalStockRecord.new(data) }
        [symbol, new(symbol: symbol, records: records)]
      end.to_h
    end

    # 转换为哈希格式
    # @return [Hash] 历史股票数据的哈希格式，包括股票代码和所有交易记录
    def to_h
      {
        symbol: @symbol,
        records: @records.map(&:to_h)
      }
    end

    # 转换为 JSON 格式
    # @return [String] 历史股票数据的 JSON 格式
    def to_json(*args)
      to_h.to_json
    end
  end

  class HistoricalStockRecord
    # 单条历史股票交易记录类
    # 解析并存储单日交易数据。

    # @!attribute [r] time
    #   @return [Time] 交易日期的时间戳
    attr_reader :time

    # @!attribute [r] open
    #   @return [Float] 当日开盘价
    attr_reader :open

    # @!attribute [r] high
    #   @return [Float] 当日最高价
    attr_reader :high

    # @!attribute [r] low
    #   @return [Float] 当日最低价
    attr_reader :low

    # @!attribute [r] close
    #   @return [Float] 当日收盘价
    attr_reader :close

    # @!attribute [r] volume
    #   @return [Integer] 当日交易量
    attr_reader :volume

    # @!attribute [r] amount
    #   @return [Float] 当日交易总金额
    attr_reader :amount

    # @!attribute [r] settlement_price
    #   @return [Float] 结算价（如果适用）
    attr_reader :settlement_price

    # @!attribute [r] open_interest
    #   @return [Integer] 未平仓合约数
    attr_reader :open_interest

    # @!attribute [r] pre_close
    #   @return [Float] 昨日收盘价
    attr_reader :pre_close

    # @!attribute [r] suspend_flag
    #   @return [Integer] 是否停牌（0: 正常交易, 1: 停牌）
    attr_reader :suspend_flag

    # 创建一个新的历史股票交易记录对象
    # @param data [Hash] 单日交易数据，包括时间戳、价格、成交量等信息
    def initialize(data)
      @time = Time.at(data["time"] / 1000)
      @open = data["open"]
      @high = data["high"]
      @low = data["low"]
      @close = data["close"]
      @volume = data["volume"]
      @amount = data["amount"]
      @settlement_price = data["settelementPrice"]
      @open_interest = data["openInterest"]
      @pre_close = data["preClose"]
      @suspend_flag = data["suspendFlag"]
    end

    # 转换为哈希格式
    # @return [Hash] 单日交易数据的哈希格式
    def to_h
      {
        time: @time,
        open: @open,
        high: @high,
        low: @low,
        close: @close,
        volume: @volume,
        amount: @amount,
        settlement_price: @settlement_price,
        open_interest: @open_interest,
        pre_close: @pre_close,
        suspend_flag: @suspend_flag
      }
    end

    # 转换为 JSON 格式
    # @return [String] 单日交易数据的 JSON 格式
    def to_json(*args)
      to_h.to_json
    end
  end

end
