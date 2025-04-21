# frozen_string_literal: true

class PositionSubscriber < ApplicationSubscriber
  channel "positions"

  def receive(msg)
    logger.info "Received message: #{msg}"
    positions = QmtModel::Holding.from_api_response JSON.parse(msg)
    t_client = TushareClient.new

    user = User.first

    positions.each do |position|
      case StockUtils.stock_type position.security_code
      in :cn_etf
        info = t_client.fund_info position.security_code
        name = info["name"]
        industry = "#{info["benchmark"]}|#{info["fund_type"]}"
        act_name = info["custodian"]
      in :cn_convertible_bond
        info = t_client.cb_info position.security_code
        name = info["bond_full_name"]
        industry = t_client.stock_info(info["stk_code"])["industry"]
        act_name = t_client.stock_info(info["stk_code"])["act_name"]
      else
        info = t_client.stock_info position.security_code
        name = info["name"]
        industry = info["industry"]
        act_name = info["act_name"]
      end


      p = StockPosition.find_or_create_by(
        account_type: position.account_type,
        stock_code: position.security_code,
        account_number: position.funds_account,
        stock_name: name,
        industry: industry,
        act_name: act_name,
        user: user
      )

      record = {
        holding_quantity: position.holding_quantity,
        opening_price: position.opening_price,
        market_value: position.market_value,
        frozen_quantity: position.frozen_quantity,
        shares_in_transit: position.in_transit_shares,
        yesterday_shares: position.yesterday_holding,
        cost_price: position.cost_price,
        available_quantity: position.available_quantity,
        last_price: position.last_price
      }.compact

      p.update record
    end

    Turbo::StreamsChannel.broadcast_replace_to "stock_positions_index",
                                               target:  "profit_sum",
                                               partial: "root/position_profit_sum",
                                               locals: { positions: StockPosition.all }
  end
end
