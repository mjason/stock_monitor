# frozen_string_literal: true

class StrategyGenService
  # @param [StockStrategy] strategy
  def initialize(strategy)
    @strategy = strategy
  end

  def prompt
    strategy_vm_file = File.read(Rails.application.root.join "app", "services", "strategy_vm.rb")
    stock_strategy_file = File.read(Rails.application.root.join "app",
                                                                "models", "stock_strategy.rb")
    stock_position_file = File.read(Rails.application.root.join "app",
                                                                "models", "stock_position.rb")

    qmt_order_model = File.read(Rails.application.root.join "app",
                                                            "services",
                                                            "qmt_model", "order_summary.rb")

    position_info = @strategy.stock_position.to_json

    <<~Markdown
    [file name]: strategy_vm.rb
    [file content begin]
    #{strategy_vm_file}
    [file content end]
    [file name]: stock_strategy.rb
    [file content begin]
    #{stock_strategy_file}
    [file content end]
    [file name]: stock_position.rb
    [file content begin]
    #{stock_position_file}
    [file content end]
    [file name]: order_summary.rb
    [file content begin]
    #{qmt_order_model}
    [file content end]
    [file name]: position.json
    [file content begin]
    #{position_info}
    [file content end]
    根据以上信息，帮我实现StockStrategy的code字段内容，实现相关的策略代码
    Markdown
  end
end
