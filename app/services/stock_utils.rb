# frozen_string_literal: true

module StockUtils
  module_function
  def stock_type(code)
    case code
    in /^(51|159)/
      :cn_etf
    in /^(110|113|123|127|128)/
      :cn_convertible_bond
    else
      :cn_stock
    end
  end
end
