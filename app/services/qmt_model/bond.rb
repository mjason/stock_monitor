# frozen_string_literal: true

module QmtModel
  class Bond < Base
    # 可转换债券数据类
    # 解析并存储可转债的交易信息，包括价格、涨跌幅等数据。

    # @!attribute [r] bond_id
    #   @return [String] 债券代码
    attr_reader :bond_id

    # @!attribute [r] bond_nm
    #   @return [String] 转债名称
    attr_reader :bond_nm

    # @!attribute [r] bond_py
    #   @return [String] 转债拼音
    attr_reader :bond_py

    # @!attribute [r] price
    #   @return [Float] 现价
    attr_reader :price

    # @!attribute [r] increase_rt
    #   @return [Float] 涨跌幅
    attr_reader :increase_rt

    # @!attribute [r] stock_id
    #   @return [String] 正股代码
    attr_reader :stock_id

    # @!attribute [r] stock_nm
    #   @return [String] 正股名称
    attr_reader :stock_nm

    # @!attribute [r] stock_py
    #   @return [String] 正股拼音
    attr_reader :stock_py

    # @!attribute [r] sprice
    #   @return [Float] 正股价
    attr_reader :sprice

    # @!attribute [r] sincrease_rt
    #   @return [Float] 正股涨跌
    attr_reader :sincrease_rt

    # @!attribute [r] pb
    #   @return [Float] 正股PB
    attr_reader :pb

    # @!attribute [r] convert_price
    #   @return [Float] 转股价
    attr_reader :convert_price

    # @!attribute [r] convert_value
    #   @return [Float] 转股价值
    attr_reader :convert_value

    # @!attribute [r] convert_dt
    #   @return [Integer] 转股日期
    attr_reader :convert_dt

    # @!attribute [r] premium_rt
    #   @return [Float] 转股溢价率
    attr_reader :premium_rt

    # @!attribute [r] dblow
    #   @return [Float] 双低
    attr_reader :dblow

    # @!attribute [r] sw_cd
    #   @return [String] 申万行业代码
    attr_reader :sw_cd

    # @!attribute [r] market_cd
    #   @return [String] 市场代码
    attr_reader :market_cd

    # @!attribute [r] btype
    #   @return [String] 债券类型
    attr_reader :btype

    # @!attribute [r] list_dt
    #   @return [String] 上市日期
    attr_reader :list_dt

    # @!attribute [r] rating_cd
    #   @return [String] 债券评级
    attr_reader :rating_cd

    # @!attribute [r] put_convert_price
    #   @return [Float] 回售触发价
    attr_reader :put_convert_price

    # @!attribute [r] force_redeem_price
    #   @return [Float] 强赎触发价
    attr_reader :force_redeem_price

    # @!attribute [r] convert_amt_ratio
    #   @return [Float] 转债占比
    attr_reader :convert_amt_ratio

    # @!attribute [r] maturity_dt
    #   @return [String] 到期时间
    attr_reader :maturity_dt

    # @!attribute [r] year_left
    #   @return [Float] 剩余年限
    attr_reader :year_left

    # @!attribute [r] curr_iss_amt
    #   @return [Float] 剩余规模
    attr_reader :curr_iss_amt

    # @!attribute [r] volume
    #   @return [Float] 成交额
    attr_reader :volume

    # @!attribute [r] turnover_rt
    #   @return [Float] 换手率
    attr_reader :turnover_rt

    # @!attribute [r] ytm_rt
    #   @return [Float] 到期税前收益
    attr_reader :ytm_rt

    # @!attribute [r] last_time
    #   @return [String] 最后更新时间
    attr_reader :last_time

    # 创建一个新的可转换债券对象
    # @param data [Hash] 债券交易数据，包括价格、正股信息等
    def initialize(data)
      @bond_id = data["bond_id"]
      @bond_nm = data["bond_nm"]
      @bond_py = data["bond_py"]
      @price = data["price"].to_f
      @increase_rt = data["increase_rt"].to_f
      @stock_id = data["stock_id"]
      @stock_nm = data["stock_nm"]
      @stock_py = data["stock_py"]
      @sprice = data["sprice"].to_f
      @sincrease_rt = data["sincrease_rt"].to_f
      @pb = data["pb"].to_f
      @convert_price = data["convert_price"].to_f
      @convert_value = data["convert_value"].to_f
      @convert_dt = data["convert_dt"]
      @premium_rt = data["premium_rt"].to_f
      @dblow = data["dblow"].to_f
      @sw_cd = data["sw_cd"]
      @market_cd = data["market_cd"]
      @btype = data["btype"]
      @list_dt = data["list_dt"]
      @rating_cd = data["rating_cd"]
      @put_convert_price = data["put_convert_price"].to_f
      @force_redeem_price = data["force_redeem_price"].to_f
      @convert_amt_ratio = data["convert_amt_ratio"].to_f
      @maturity_dt = data["maturity_dt"]
      @year_left = data["year_left"].to_f
      @curr_iss_amt = data["curr_iss_amt"].to_f
      @volume = data["volume"].to_f
      @turnover_rt = data["turnover_rt"].to_f
      @ytm_rt = data["ytm_rt"].to_f
      @last_time = data["last_time"]
    end

    # 计算转债代码对应的交易所后缀
    # @return [String] 带交易所后缀的债券代码
    def symbol
      exchange = if @market_cd&.start_with?("sh")
                   "SH"
                 else
                   "SZ"
                 end
      "#{@bond_id}.#{exchange}"
    end

    # 计算等级
    # @return [Integer] 等级
    # @note 1-10 分别表示 AAA、AA+、AA、AA-、A+、A、BBB+、BBB-、BB、B
    def level
      case @rating_cd
      when "AAA"
        1
      when "AA+"
        2
      when "AA"
        3
      when "AA-"
        4
      when "A+"
        5
      when "A"
        6
      when "BBB+"
        7
      when "BBB-"
        8
      when "BB"
        9
      when "B"
        10
      else
        10
      end
    end

    # 从 API 响应中解析可转债数据
    # @param response [Array<Hash>] API 返回的可转换债券数据数组
    # @return [Array<Bond>] 解析后的可转债数据对象数组
    def self.from_api_response(response)
      response.filter { |data| data.fetch("market_cd", "") =~ /sh|sz/ }.map { |data| new(data) }
    end

    # 转换为哈希格式
    # @return [Hash] 可转债数据的哈希格式
    def to_h
      {
        bond_id: @bond_id,
        bond_nm: @bond_nm,
        bond_py: @bond_py,
        price: @price,
        increase_rt: @increase_rt,
        stock_id: @stock_id,
        stock_nm: @stock_nm,
        stock_py: @stock_py,
        sprice: @sprice,
        sincrease_rt: @sincrease_rt,
        pb: @pb,
        convert_price: @convert_price,
        convert_value: @convert_value,
        convert_dt: @convert_dt,
        premium_rt: @premium_rt,
        dblow: @dblow,
        sw_cd: @sw_cd,
        market_cd: @market_cd,
        btype: @btype,
        list_dt: @list_dt,
        rating_cd: @rating_cd,
        put_convert_price: @put_convert_price,
        force_redeem_price: @force_redeem_price,
        convert_amt_ratio: @convert_amt_ratio,
        maturity_dt: @maturity_dt,
        year_left: @year_left,
        curr_iss_amt: @curr_iss_amt,
        volume: @volume,
        turnover_rt: @turnover_rt,
        ytm_rt: @ytm_rt,
        last_time: @last_time,
        symbol: symbol
      }
    end

    # 转换为 JSON 格式
    # @return [String] 可转债数据的 JSON 格式
    def to_json(*args)
      to_h.to_json
    end

    # 计算双低值（价格 + 溢价率）
    # @return [Float] 双低值
    def calculate_dblow
      @price + @premium_rt
    end

    # 检查是否存在强赎风险
    # @return [Boolean] 是否存在强赎风险
    def redemption_risk?
      @sprice >= @force_redeem_price
    end

    # 检查是否触发回售条件
    # @return [Boolean] 是否触发回售条件
    def put_condition_met?
      @sprice <= @put_convert_price
    end
  end
end