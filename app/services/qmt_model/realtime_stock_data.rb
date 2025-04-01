module QmtModel
  class RealtimeStockData < Base
    # 实时股票数据类
    # 解析并存储实时交易系统返回的股票数据，包括价格、交易量等信息。

    # @!attribute [r] symbol
    #   @return [String] 股票代码，例如 "600519.SH"
    attr_reader :symbol

    # @!attribute [r] timestamp
    #   @return [String] 数据时间戳，例如 "20250306 14:08:11"
    attr_reader :timestamp

    # @!attribute [r] last_price
    #   @return [Float] 最新成交价
    attr_reader :last_price

    # @!attribute [r] open
    #   @return [Float] 当日开盘价
    attr_reader :open

    # @!attribute [r] high
    #   @return [Float] 当日最高价
    attr_reader :high

    # @!attribute [r] low
    #   @return [Float] 当日最低价
    attr_reader :low

    # @!attribute [r] last_close
    #   @return [Float] 昨日收盘价
    attr_reader :last_close

    # @!attribute [r] amount
    #   @return [Float] 交易总金额
    attr_reader :amount

    # @!attribute [r] volume
    #   @return [Integer] 交易总量
    attr_reader :volume

    # @!attribute [r] pvolume
    #   @return [Integer] 盘中累计成交量
    attr_reader :pvolume

    # @!attribute [r] stock_status
    #   @return [Integer] 股票交易状态
    attr_reader :stock_status

    # @!attribute [r] open_interest
    #   @return [Integer] 未平仓合约数
    attr_reader :open_interest

    # @!attribute [r] settlement_price
    #   @return [Float] 结算价（如果适用）
    attr_reader :settlement_price

    # @!attribute [r] last_settlement_price
    #   @return [Float] 上次结算价
    attr_reader :last_settlement_price

    # @!attribute [r] ask_prices
    #   @return [Array<Float>] 卖盘报价列表
    attr_reader :ask_prices

    # @!attribute [r] bid_prices
    #   @return [Array<Float>] 买盘报价列表
    attr_reader :bid_prices

    # @!attribute [r] ask_volumes
    #   @return [Array<Integer>] 卖盘数量列表
    attr_reader :ask_volumes

    # @!attribute [r] bid_volumes
    #   @return [Array<Integer>] 买盘数量列表
    attr_reader :bid_volumes

    # 创建一个新的实时股票数据对象
    # @param symbol [String] 股票代码
    # @param timestamp [String] 数据时间戳
    # @param last_price [Float] 最新成交价
    # @param open [Float] 当日开盘价
    # @param high [Float] 当日最高价
    # @param low [Float] 当日最低价
    # @param last_close [Float] 昨日收盘价
    # @param amount [Float] 交易总金额
    # @param volume [Integer] 交易总量
    # @param pvolume [Integer] 盘中累计成交量
    # @param stock_status [Integer] 股票交易状态
    # @param open_interest [Integer] 未平仓合约数
    # @param settlement_price [Float] 结算价
    # @param last_settlement_price [Float] 上次结算价
    # @param ask_prices [Array<Float>] 卖盘报价列表
    # @param bid_prices [Array<Float>] 买盘报价列表
    # @param ask_volumes [Array<Integer>] 卖盘数量列表
    # @param bid_volumes [Array<Integer>] 买盘数量列表
    def initialize(symbol:, timestamp:, last_price:, open:, high:, low:, last_close:,
                   amount:, volume:, pvolume:, stock_status:, open_interest:,
                   settlement_price:, last_settlement_price:, ask_prices:, bid_prices:,
                   ask_volumes:, bid_volumes:)
      @symbol = symbol
      @timestamp = timestamp
      @last_price = last_price
      @open = open
      @high = high
      @low = low
      @last_close = last_close
      @amount = amount
      @volume = volume
      @pvolume = pvolume
      @stock_status = stock_status
      @open_interest = open_interest
      @settlement_price = settlement_price
      @last_settlement_price = last_settlement_price
      @ask_prices = ask_prices
      @bid_prices = bid_prices
      @ask_volumes = ask_volumes
      @bid_volumes = bid_volumes
    end

    # 从 API 响应中解析股票数据
    # @param response [Hash] API 返回的股票数据
    # @return [Hash<String, RealtimeStockData>] 解析后的实时股票数据对象数组
    def self.from_api_response(response)
      response.map do |symbol, data|
        data = new(
          symbol: symbol,
          timestamp: data["timetag"],
          last_price: data["lastPrice"],
          open: data["open"],
          high: data["high"],
          low: data["low"],
          last_close: data["lastClose"],
          amount: data["amount"],
          volume: data["volume"],
          pvolume: data["pvolume"],
          stock_status: data["stockStatus"],
          open_interest: data["openInt"],
          settlement_price: data["settlementPrice"],
          last_settlement_price: data["lastSettlementPrice"],
          ask_prices: data["askPrice"],
          bid_prices: data["bidPrice"],
          ask_volumes: data["askVol"],
          bid_volumes: data["bidVol"]
        )
        [symbol.to_s, data]
      end.to_h
    end

    # 转换为哈希格式
    # @return [Hash] 股票数据的哈希格式
    def to_h
      {
        symbol: @symbol,
        timestamp: @timestamp,
        last_price: @last_price,
        open: @open,
        high: @high,
        low: @low,
        last_close: @last_close,
        amount: @amount,
        volume: @volume,
        pvolume: @pvolume,
        stock_status: @stock_status,
        open_interest: @open_interest,
        settlement_price: @settlement_price,
        last_settlement_price: @last_settlement_price,
        ask_prices: @ask_prices,
        bid_prices: @bid_prices,
        ask_volumes: @ask_volumes,
        bid_volumes: @bid_volumes
      }
    end

    # 转换为 JSON 格式
    # @return [String] 股票数据的 JSON 格式
    def to_json(*args)
      JSON.generate to_h
    end
  end
end
