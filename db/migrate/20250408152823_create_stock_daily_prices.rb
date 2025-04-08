class CreateStockDailyPrices < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_daily_prices do |t|
      t.string :ts_code, null: false, comment: '股票代码'
      t.string :trade_date, null: false, comment: '交易日期'
      t.float :open, comment: '开盘价'
      t.float :high, comment: '最高价'
      t.float :low, comment: '最低价'
      t.float :close, comment: '收盘价'
      t.float :pre_close, comment: '昨收价'
      t.float :change, comment: '涨跌额'
      t.float :pct_chg, comment: '涨跌幅'
      t.float :vol, comment: '成交量'
      t.float :amount, comment: '成交额'

      t.timestamps
    end

    add_index :stock_daily_prices, [:ts_code, :trade_date], unique: true
    add_index :stock_daily_prices, :trade_date
  end
end
