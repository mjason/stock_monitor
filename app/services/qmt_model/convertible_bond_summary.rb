# frozen_string_literal: true

module QmtModel
  class ConvertibleBondSummary
    # 可转换债券摘要类
    # 解析并存储可转债的关键信息，包括基本信息和募投项目。

    # @!attribute [r] symbol
    #   @return [String] 债券证券代码，例如 "123219.SZ"
    attr_reader :symbol

    # @!attribute [r] bond_name
    #   @return [String] 债券名称，例如 "宇瞳转债"
    attr_reader :bond_name

    # @!attribute [r] issue_year
    #   @return [String] 发行年份，例如 "2023"
    attr_reader :issue_year

    # @!attribute [r] bond_expire
    #   @return [Float] 债券期限（年）
    attr_reader :bond_expire

    # @!attribute [r] convert_stock_code
    #   @return [String] 转换股票代码，例如 "300790"
    attr_reader :convert_stock_code

    # @!attribute [r] convert_stock_price
    #   @return [Float] 初始转股价格
    attr_reader :convert_stock_price

    # @!attribute [r] interest_rate
    #   @return [String] 利率说明
    attr_reader :interest_rate

    # @!attribute [r] redeem_clause
    #   @return [String] 赎回条款
    attr_reader :redeem_clause

    # @!attribute [r] resale_clause
    #   @return [String] 回售条款
    attr_reader :resale_clause

    # @!attribute [r] rating
    #  @return [String] 债券评级
    attr_reader :rating

    # @!attribute [r] projects
    #   @return [Array<Hash>] 募投项目列表，每个项目包含项目名称、计划投资金额、已投入金额等信息
    attr_reader :projects

    # 创建一个新的可转换债券摘要对象
    # @param bond_data [Hash] 债券基础数据
    # @param project_data [Array<Hash>] 募投项目数据
    def initialize(bond_data, project_data)
      @symbol = bond_data["SECUCODE"]
      @bond_name = bond_data["SECURITY_NAME_ABBR"] || bond_data["BOND_NAME_ABBR"]
      @issue_year = bond_data["ISSUE_YEAR"]
      @bond_expire = bond_data["BOND_EXPIRE"].to_f
      @convert_stock_code = bond_data["CONVERT_STOCK_CODE"]
      @convert_stock_price = bond_data["CONVERT_STOCK_PRICE"].to_f
      @interest_rate = bond_data["INTEREST_RATE_EXPLAIN"]
      @redeem_clause = bond_data["REDEEM_CLAUSE"]
      @resale_clause = bond_data["RESALE_CLAUSE"]

      @rating = bond_data["RATING"]

      @projects = project_data.map do |proj|
        {
          item_name: proj["ITEM_NAME"],
          plan_invest_amt: proj["PLAN_INVEST_AMT"].to_f,
          actual_input_rf: proj["ACTUAL_INPUT_RF"].to_f,
          invest_return_1y: proj["INVEST_RETURN_1Y"].to_f
        }
      end
    end

    # 从 API 响应中解析可转债数据
    # @param response [Array<Hash>] API 返回的可转换债券数据数组
    # @return [ConvertibleBondSummary] 解析后的可转债摘要对象数组
    def self.from_api_response(response)
      bond_data = response.find { |d| d["SECUCODE"] && d["SECURITY_CODE"] }
      project_data = response.select { |d| d["ITEM_NAME"] }
      return nil unless bond_data
      new(bond_data, project_data)
    end

    # 转换为哈希格式
    # @return [Hash] 可转债摘要数据的哈希格式
    def to_h
      {
        symbol: @symbol,
        bond_name: @bond_name,
        issue_year: @issue_year,
        bond_expire: @bond_expire,
        convert_stock_code: @convert_stock_code,
        convert_stock_price: @convert_stock_price,
        interest_rate: @interest_rate,
        redeem_clause: @redeem_clause,
        resale_clause: @resale_clause,
        projects: @projects,
        rating: @rating
      }
    end

    # 转换为 JSON 格式
    # @return [String] 可转债摘要数据的 JSON 格式
    def to_json(*args)
      to_h.to_json
    end
  end

end
