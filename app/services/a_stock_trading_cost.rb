class AStockTradingCost
  # 默认费率
  COMMISSION_RATE = 0.0001  # 佣金费率 0.01%
  MIN_COMMISSION = 5.0      # 最低佣金 5元
  STAMP_DUTY = 0.001        # 印花税 0.1% (仅卖出时收取)

  # 交易所经手费
  SH_EXCHANGE_FEE_RATE = 0.000341  # 上交所经手费 0.0341%
  SZ_EXCHANGE_FEE_RATE = 0.000341  # 深交所经手费 0.0341%

  # 过户费
  SH_TRANSFER_FEE_RATE = 0.00002  # 上海过户费 0.002% 
  SH_MIN_TRANSFER_FEE = 1.0       # 上海最低过户费 1元
  SZ_TRANSFER_FEE_RATE = 0.00001  # 深圳过户费 0.001%

  # 证券监管费
  REGULATORY_FEE = 0.00002  # 监管费 0.002%

  # 初始化方法
  # @param commission_rate [Float] 佣金费率，默认0.03%
  # @param min_commission [Float] 最低佣金，默认5元
  def initialize(commission_rate: COMMISSION_RATE, min_commission: MIN_COMMISSION)
    @commission_rate = commission_rate
    @min_commission = min_commission
  end

  # 计算买入成本
  # @param code [String] 股票代码
  # @param amount [Float, BigDecimal] 交易金额(元)
  # @return [Hash] 包含各项费用和总成本的哈希表
  def buy_cost_for_code(code, amount)
    security_type = StockUtils.get_security_type(code)
    exchange = code.split(".").last.downcase.to_sym

    buy_cost amount, exchange: exchange, security_type: security_type
  end

  # 计算买入成本
  # @param amount [Float, BigDecimal] 交易金额(元)
  # @param exchange [Symbol] 交易所，:sh 或 :sz
  # @param security_type [Symbol] 证券类型，:stock(股票), :fund(基金), :bond(债券), :convertible_bond(可转债)
  # @return [Hash] 包含各项费用和总成本的哈希表
  def buy_cost(amount, exchange: :sh, security_type: :stock)
    # 券商佣金
    commission = calculate_commission(amount)

    # 交易所经手费
    exchange_fee = calculate_exchange_fee(amount, exchange, security_type)

    # 过户费
    transfer_fee = calculate_transfer_fee(amount, exchange)

    # 监管费 (仅股票收取)
    regulatory_fee = security_type == :stock ? amount * REGULATORY_FEE : 0.0

    total_fee = commission + exchange_fee + transfer_fee + regulatory_fee
    total_cost = amount + total_fee

    {
      amount: amount,
      commission: commission,
      exchange_fee: exchange_fee,
      transfer_fee: transfer_fee,
      regulatory_fee: regulatory_fee,
      total_fee: total_fee,
      total_cost: total_cost,
      fee_rate: total_fee / amount
    }
  end

  # 计算卖出成本
  # @param code [String] 股票代码
  # @param amount [Float, BigDecimal] 交易金额(元)
  # @return [Hash] 包含各项费用和总成本的哈希表
  def sell_cost_for_code(code, amount)
    security_type = StockUtils.get_security_type(code)
    exchange = code.split(".").last.downcase.to_sym

    sell_cost amount, exchange: exchange, security_type: security_type
  end

  # 计算卖出成本
  # @param amount [Float, BigDecimal] 交易金额(元)
  # @param exchange [Symbol] 交易所，:sh 或 :sz
  # @param security_type [Symbol] 证券类型，:stock(股票), :fund(基金), :bond(债券), :convertible_bond(可转债)
  # @return [Hash] 包含各项费用和实际所得的哈希表
  def sell_cost(amount, exchange: :sh, security_type: :stock)
    # 券商佣金
    commission = calculate_commission(amount)

    # 交易所经手费
    exchange_fee = calculate_exchange_fee(amount, exchange, security_type)

    # 过户费
    transfer_fee = calculate_transfer_fee(amount, exchange)

    # 印花税 (仅股票卖出时收取)
    stamp_duty = security_type == :stock ? amount * STAMP_DUTY : 0.0

    # 监管费 (仅股票收取)
    regulatory_fee = security_type == :stock ? amount * REGULATORY_FEE : 0.0

    total_fee = commission + exchange_fee + transfer_fee + stamp_duty + regulatory_fee
    actual_gain = amount - total_fee

    {
      amount: amount,
      commission: commission,
      exchange_fee: exchange_fee,
      transfer_fee: transfer_fee,
      stamp_duty: stamp_duty,
      regulatory_fee: regulatory_fee,
      total_fee: total_fee,
      actual_gain: actual_gain,
      fee_rate: total_fee / amount
    }
  end

  private

  # 计算佣金
  def calculate_commission(amount)
    commission = amount * @commission_rate
    [commission, @min_commission].max
  end

  # 计算交易所经手费
  def calculate_exchange_fee(amount, exchange, security_type)
    # 根据证券类型和交易所选择费率
    rate = case security_type
           when :stock
             exchange == :sh ? SH_EXCHANGE_FEE_RATE : SZ_EXCHANGE_FEE_RATE
           when :fund
             0.00004  # 基金经手费率 0.004%
           when :bond
             0.0      # 债券经手费 2022年7月1日至2025年12月31日暂免
           when :convertible_bond
             0.00004  # 可转债经手费率 0.004%
           else
             exchange == :sh ? SH_EXCHANGE_FEE_RATE : SZ_EXCHANGE_FEE_RATE
           end

    amount * rate
  end

  # 计算过户费
  def calculate_transfer_fee(amount, exchange)
    case exchange
    when :sh
      fee = amount * SH_TRANSFER_FEE_RATE
      [fee, SH_MIN_TRANSFER_FEE].max
    when :sz
      amount * SZ_TRANSFER_FEE_RATE
    else
      raise ArgumentError, "交易所参数必须为 :sh 或 :sz"
    end
  end
end

# 使用示例
if __FILE__ == $0
  # 创建交易成本计算器实例
  calculator = AStockTradingCost.new

  # 1. 计算10000元在上海交易所买入A股的成本
  puts "===== 上海交易所A股买入 ====="
  buy_result = calculator.buy_cost(10000, exchange: :sh)
  puts "交易金额: #{buy_result[:amount]}元"
  puts "佣金: #{buy_result[:commission].round(2)}元"
  puts "经手费: #{buy_result[:exchange_fee].round(2)}元"
  puts "过户费: #{buy_result[:transfer_fee].round(2)}元"
  puts "监管费: #{buy_result[:regulatory_fee].round(2)}元"
  puts "总费用: #{buy_result[:total_fee].round(2)}元"
  puts "总成本: #{buy_result[:total_cost].round(2)}元"
  puts "总费用率: #{(buy_result[:fee_rate] * 100).round(4)}%"
  puts

  # 2. 计算10000元在上海交易所卖出A股的成本
  puts "===== 上海交易所A股卖出 ====="
  sell_result = calculator.sell_cost(10000, exchange: :sh)
  puts "交易金额: #{sell_result[:amount]}元"
  puts "佣金: #{sell_result[:commission].round(2)}元"
  puts "经手费: #{sell_result[:exchange_fee].round(2)}元"
  puts "过户费: #{sell_result[:transfer_fee].round(2)}元"
  puts "印花税: #{sell_result[:stamp_duty].round(2)}元"
  puts "监管费: #{sell_result[:regulatory_fee].round(2)}元"
  puts "总费用: #{sell_result[:total_fee].round(2)}元"
  puts "实际所得: #{sell_result[:actual_gain].round(2)}元"
  puts "总费用率: #{(sell_result[:fee_rate] * 100).round(4)}%"
  puts

  # 3. 计算10000元在深圳交易所买入A股的成本
  puts "===== 深圳交易所A股买入 ====="
  sz_buy_result = calculator.buy_cost(10000, exchange: :sz)
  puts "交易金额: #{sz_buy_result[:amount]}元"
  puts "佣金: #{sz_buy_result[:commission].round(2)}元"
  puts "经手费: #{sz_buy_result[:exchange_fee].round(2)}元"
  puts "过户费: #{sz_buy_result[:transfer_fee].round(2)}元"
  puts "监管费: #{sz_buy_result[:regulatory_fee].round(2)}元"
  puts "总费用: #{sz_buy_result[:total_fee].round(2)}元"
  puts "总成本: #{sz_buy_result[:total_cost].round(2)}元"
  puts "总费用率: #{(sz_buy_result[:fee_rate] * 100).round(4)}%"
  puts

  # 4. 计算10000元ETF基金买入的成本
  puts "===== 上海交易所ETF基金买入 ====="
  fund_buy_result = calculator.buy_cost(10000, exchange: :sh, security_type: :fund)
  puts "交易金额: #{fund_buy_result[:amount]}元"
  puts "佣金: #{fund_buy_result[:commission].round(2)}元"
  puts "经手费: #{fund_buy_result[:exchange_fee].round(2)}元"
  puts "过户费: #{fund_buy_result[:transfer_fee].round(2)}元"
  puts "监管费: #{fund_buy_result[:regulatory_fee].round(2)}元"
  puts "总费用: #{fund_buy_result[:total_fee].round(2)}元"
  puts "总成本: #{fund_buy_result[:total_cost].round(2)}元"
  puts "总费用率: #{(fund_buy_result[:fee_rate] * 100).round(4)}%"
  puts

  # 5. 计算10000元可转债买入的成本
  puts "===== 上海交易所可转债买入 ====="
  cb_buy_result = calculator.buy_cost(10000, exchange: :sh, security_type: :convertible_bond)
  puts "交易金额: #{cb_buy_result[:amount]}元"
  puts "佣金: #{cb_buy_result[:commission].round(2)}元"
  puts "经手费: #{cb_buy_result[:exchange_fee].round(2)}元"
  puts "过户费: #{cb_buy_result[:transfer_fee].round(2)}元"
  puts "监管费: #{cb_buy_result[:regulatory_fee].round(2)}元"
  puts "总费用: #{cb_buy_result[:total_fee].round(2)}元"
  puts "总成本: #{cb_buy_result[:total_cost].round(2)}元"
  puts "总费用率: #{(cb_buy_result[:fee_rate] * 100).round(4)}%"
end