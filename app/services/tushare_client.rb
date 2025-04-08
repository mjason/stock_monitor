# frozen_string_literal: true

class TushareClient

  DEFAULT_ENDPOINT = "https://api.tushare.pro"

  def initialize(api_key: nil, end_point: nil, cache: nil,
                 enable_cache: true, prefix_key: "tushare:",
                 expires_in: 1.days,
                 logger: nil)
    @api_key = api_key || ENV.fetch("TUSHARE_API_KEY")
    @endpoint = end_point || ENV.fetch("TUSHARE_ENDPOINT", DEFAULT_ENDPOINT)
    @cache = cache || Rails.cache
    @enable_cache = enable_cache
    @prefix_key = prefix_key
    @expires_in = expires_in
    @logger = logger || Rails.logger
  end

  def stock_basic
    cache_pd "stock_basic" do
      request api_name: "stock_basic"
    end
  end

  def stock_info(code)
    stock_basic.find { it["ts_code"] == code }
  end

  def fund_basic
    cache_pd "fund_basic" do
      request api_name: "fund_basic", params: { market: "E" }
    end
  end

  def fund_info(code)
    fund_basic.find { it["ts_code"] == code }
  end

  def cb_basic
    cache_pd "cb_basic" do
      request api_name: "cb_basic"
    end
  end

  def cb_info(code)
    cb_basic.find { it["ts_code"] == code }
  end

  def daily(codes, start_date: nil, end_date: nil)
    codes = codes.join(",") if codes.is_a? Array
    start_date ||= (Time.now - 3.years).strftime("%Y%m%d")
    end_date ||= Time.now.strftime("%Y%m%d")

    request(api_name: "daily",
            params: { ts_code: codes, start_date: start_date, end_date: end_date })
      .then { pd(it["data"]) }
  end

  def fund_daily(codes, start_date: nil, end_date: nil)
    codes = codes.join(",") if codes.is_a? Array
    start_date ||= (Time.now - 3.years).strftime("%Y%m%d")
    end_date ||= Time.now.strftime("%Y%m%d")

    request(api_name: "fund_daily",
            params: { ts_code: codes, start_date: start_date, end_date: end_date })
      .then { pd(it["data"]) }
  end

  def cb_daily(codes, start_date: nil, end_date: nil)
    codes = codes.join(",") if codes.is_a? Array
    start_date ||= (Time.now - 3.years).strftime("%Y%m%d")
    end_date ||= Time.now.strftime("%Y%m%d")

    request(api_name: "cb_daily",
            params: { ts_code: codes, start_date: start_date, end_date: end_date })
      .then { pd(it["data"]) }
  end

  private
  def build_request_body(api_name:, params: {}, fields: "")
    {
      api_name: api_name,
      params: params,
      fields: fields,
      token: @api_key
    }
  end

  def request(api_name:, params: {}, fields: "")
    @logger.debug "TushareClient: requesting tushare #{api_name}"
    response =  HTTP.post(@endpoint, json:
      build_request_body(api_name: api_name, params: params, fields: fields)
    )
    @logger.debug "TushareClient: response code: #{response.code}"
    @logger.debug "TushareClient: response: #{response.body}"
    JSON.parse(response.body.to_s)
  end

  def cache_write(key, value)
    return false unless @enable_cache
    @cache.write(translate_key(key), value, expires_in: @expires_in)
  end

  def cache_read(key, &block)
    case value = @cache.read(translate_key key) || block.call
    in String
      JSON.parse value
    else
      value
    end
  end

  def cache(key, &block)
    cache_read(key) do
      case value = block.call
      in String
        cache_write(key, value)
      else
        cache_write(key, value.to_json)
      end
      value
    end
  end

  def cache_pd(key, &block)
    data = cache(key, &block)
    pd data["data"]
  end

  def translate_key(key)
    "#{@prefix_key}#{key}"
  end

  def pd(data)
    fields = data["fields"]
    items = data["items"]
    items.map { Hash[fields.zip(it)] }
  end

end
