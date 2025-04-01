module Httpx
  module_function
  def get(url, params: {})
    HTTP.get(url, params: params) # steep:ignore
  end

  def fetch_jisilu_data
    # 使用当前时间作为 if-modified-since 头部
    current_time = Time.now.httpdate
    # 设置 cookie
    cookies = ENV.fetch("JISILU_COOKIE", "kbzw__Session=9mbac64kjsqj074au6r0pf9e47; kbz_newcookie=1; kbzw__user_login=7Obd08_P1ebax9aXwZKrkqypp6qZpYKvpuXK7N_u0ejF1dSe3sWkk6fcrsrd0qmYppjY2Niol9OZqqrazdzRqpKtl7CYrqXW2cXS1qCbqp2sk6aamLKgubXOvp-qrJ2qo62Sp5SwmK6ltrG_0aTC2PPV487XkKylo5iJvcLX4uPd6N_fnZaq5evY5IG9wteZxLyZxJeTpsCorNKvipCi5OnhztDR2a3f1aaspq-Po5eUocCxzbnDjpbN4OLYmKjVxN_onom81OnR48amqKarj6CPpKeliczN3cPoyqaspq-Po5c.")

    headers = {
      "accept" => "application/json, text/plain, */*",
      "accept-language" => "zh-CN,zh;q=0.9,en;q=0.8,en-US;q=0.7",
      "columns" => "1,70,2,3,5,6,11,12,14,15,16,29,30,32,34,44,46,47,50,52,53,54,56,57,58,59,60,62,63,67",
      "if-modified-since" => current_time,
      "init" => "1",
      "priority" => "u=1, i",
      "referer" => "https://www.jisilu.cn/web/data/cb/list",
      "sec-ch-ua" => '"Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"',
      "sec-ch-ua-mobile" => "?0",
      "sec-ch-ua-platform" => '"macOS"',
      "sec-fetch-dest" => "empty",
      "sec-fetch-mode" => "cors",
      "sec-fetch-site" => "same-origin",
      "user-agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36",
      "Cookie" => cookies
    }

    HTTP.headers(headers).get("https://www.jisilu.cn/webapi/cb/list/").body.to_s # steep:ignore
  end
end
