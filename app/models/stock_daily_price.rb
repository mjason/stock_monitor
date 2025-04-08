class StockDailyPrice < ApplicationRecord
  DEFAULT_START_TIME = "20230101"

  class << self

    def sync(codes)
      sync_all codes, start_time: (Time.now - 3.days).strftime("%Y%m%d")
    end

    def sync_all(codes, start_time: nil)
      codes = [ codes ] unless codes.is_a?(Array)
      tushare_client = TushareClient.new
      start_time ||= DEFAULT_START_TIME

      security_codes = codes.group_by { StockUtils.stock_type(it) }
      records = []
      security_codes.each do |stock_type, code_list|
        case stock_type
        in :cn_stock
          records += tushare_client.daily(code_list, start_date: start_time)
        in :cn_convertible_bond
          records += tushare_client.cb_daily(code_list, start_date: start_time)
        in :cn_etf
          records += tushare_client.fund_daily(code_list, start_date: start_time)
        else
          nil
        end
      end

      records_to_upsert = records.map do |data|
        {
          ts_code: data["ts_code"],
          trade_date: data["trade_date"],
          open: data["open"],
          high: data["high"],
          low: data["low"],
          close: data["close"],
          pre_close: data["pre_close"],
          change: data["change"],
          pct_chg: data["pct_chg"],
          vol: data["vol"],
          amount: data["amount"]
        }
      end

      self.upsert_all(records_to_upsert, unique_by: [:ts_code, :trade_date])
    end
  end
end
