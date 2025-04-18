# frozen_string_literal: true

class Notification
  def initialize(uid: nil, send_key: nil)
    @uid = uid || ENV.fetch("FT07_UID")
    @send_key = send_key || ENV.fetch("FT07_SEND_KEY")
  end

  def send(title:, desp: nil, tags: nil, short: nil)
    data = {
      title: title,
      desp: desp,
      tags: tags,
      short: short
    }.compact

    HTTP.post("https://#{@uid}.push.ft07.com/send/#{@send_key}.send", json: data)
  end
end
