# frozen_string_literal: true

class QmtClient
  BASE_URL = ENV.fetch("STOCK_HOST", "http://10.43.142.63:8000")

  ENDPOINTS = {
    reload: "#{BASE_URL}/reload",
    account: "#{BASE_URL}/account",
    positions: "#{BASE_URL}/positions",
    get_full_tick: "#{BASE_URL}/get-full-tick",
    get_local_data: "#{BASE_URL}/get-local-data",
    bond_zh_hs_cov_spot: "#{BASE_URL}/bond_zh_hs_cov_spot",
    bond_zh_cov_info: "#{BASE_URL}/bond_zh_cov_info",
    buy: "#{BASE_URL}/buy",
    sell: "#{BASE_URL}/sell",
    cancel: "#{BASE_URL}/cancel",
    stock_orders: "#{BASE_URL}/orders"
  }


  # 重启股票数据服务
  def reload
    JSON.parse(Httpx.get(ENDPOINTS[:reload]).to_s).dig("status")
  end

  # 获取账户信息
  # @return [QmtModel::Account] 账户信息对象
  def account
    QmtModel::Account.from_api_response JSON.parse(Httpx.get(ENDPOINTS[:account]).body.to_s)
  end

  # 获取持仓信息
  def positions
    QmtModel::Holding.from_api_response JSON.parse(Httpx.get(ENDPOINTS[:positions]).body.to_s)
  end

  # 获取实时股票数据
  # @param codes [String, Array<String>] 股票代码列表
  # @return [Hash[String, QmtModel::RealtimeStockData]] 股票代码和对应的实时数据
  def get_full_tick(codes)
    codes = codes.join(",") if codes.is_a?(Array)
    QmtModel::RealtimeStockData.from_api_response JSON.parse(
      Httpx.get(ENDPOINTS[:get_full_tick], params: {stock_list: codes}).body.to_s
    )
  end

  # 获取历史数据
  # @param codes [String, Array<String>] 股票代码列表
  # @param start_time [Time] 开始日期
  # @param end_time [Time] 结束日期
  # @param period [String] 数据周期，默认为 "1d", 可选择 1m、5m、1d、tick
  # @return [Hash[Symbol, HistoricalStockData] 股票代码和对应的历史数据
  def get_history_data(codes, start_time: nil, end_time: nil, period: "1d")
    codes = codes.join(",") if codes.is_a?(Array)
    start_time = (start_time || (Date.today << 24).to_time).strftime('%Y%m%d')
    end_time = (end_time || Time.now).strftime('%Y%m%d')

    response = Httpx.get(ENDPOINTS[:get_local_data], params: {
      stock_list: codes,
      start_date: start_time,
      end_date: end_time,
      period: period
    })

    QmtModel::HistoricalStockData.from_api_response JSON.parse(response.body.to_s)
  end

  # 获取债券数据
  # @return [Array<QmtModel::ConvertibleBond>] 可转债数据对象数组
  def get_bond_list
    response = Httpx.get(ENDPOINTS[:bond_zh_hs_cov_spot])
    QmtModel::ConvertibleBond.from_api_response JSON.parse(response.body.to_s)
  end

  # 获取可转债详细信息
  # @param code [String] 可转债代码
  # @return [QmtModel::ConvertibleBondSummary, nil] 可转债摘要对象
  def get_bond_info(code)
    code = code.split('.').first if code.include?('.')
    response = Httpx.get(ENDPOINTS[:bond_zh_cov_info], params: {code: code})
    QmtModel::ConvertibleBondSummary.from_api_response JSON.parse(response.body.to_s)
  end

  # 购买股票
  # @param stock_code [String] 股票代码
  # @param order_volume [Integer] 购买数量
  # @param price [Float] 购买价格
  # @return [Integer] 订单编号
  def buy(stock_code, order_volume, price)
    response = Httpx.get(ENDPOINTS[:buy], params: {
      stock_code: stock_code, order_volume: order_volume, price: price
    })
    JSON.parse(response.body.to_s).dig("order_id")
  end

  # 取消订单
  # @param order_id [Integer] 订单编号
  # @return [Boolean] 是否成功取消订单
  def cancel(order_id)
    response = Httpx.get(ENDPOINTS[:cancel], params: {order_id: order_id})
    response.body.to_s.to_i == 0
  end

  # 卖出股票
  # @param stock_code [String] 股票代码
  # @param order_volume [Integer] 卖出数量
  # @param price [Float] 卖出价格
  # @return [Integer] 订单编号
  def snell(stock_code, order_volume, price)
    response = Httpx.get(ENDPOINTS[:sell], params: {
      stock_code: stock_code, order_volume: order_volume, price: price
    })
    JSON.parse(response.body.to_s).dig("order_id")
  end

  # 获取订单列表
  # @return [Array<QmtModel::OrderSummary>] 订单列表对象数组
  def stock_orders
    response = Httpx.get(ENDPOINTS[:stock_orders])
    QmtModel::OrderSummary.from_api_response JSON.parse(response.body.to_s)
  end

  # 集思录可转债数据
  # @return [Array<QmtModel::Bond>] 集思录可转债数据对象数组
  def jisilu_cb
    QmtModel::Bond.from_api_response JSON.parse(Httpx.fetch_jisilu_data).dig("data")
  end
end
