class StockStrategy < ApplicationRecord
  # 枚举定义
  enum :security_type, { stock: 0, etf: 1, convertible_bond: 2 }

  # 验证
  validates :name, presence: true
  validates :stock_symbol, presence: true, uniqueness: true
  validates :security_type, presence: true

  # 日志方法 - 添加新价格到价格日志
  def add_price(price)
    current_log = price_log || []
    # 保持最新的5条记录
    updated_log = (current_log + [{ price: price, timestamp: Time.current }]).last(5)
    update(price_log: updated_log)
  end

  # 获取最新价格
  def latest_price
    return nil if price_log.blank?
    price_log.last&.dig("price")
  end

  # 执行策略
  def execute_strategy
    if simple?
      execute_simple_strategy
    elsif custom?
      execute_custom_strategy
    end
  end

  private

  # 简单策略实现
  def execute_simple_strategy
    # 默认简单策略实现
    # 例如：移动平均线策略等
    # 这里可以实现默认的策略逻辑
    "执行简单策略: #{name} (#{stock_symbol})"
  end

  # 自定义策略实现
  def execute_custom_strategy
    # 使用eval执行自定义代码
    # 注意：在生产环境中应该避免直接使用eval，这里仅作为示例
    # 应该使用更安全的方式执行自定义代码，如：沙箱环境
    begin
      eval(code)
    rescue StandardError => e
      "自定义策略执行错误: #{e.message}"
    end
  end
end
