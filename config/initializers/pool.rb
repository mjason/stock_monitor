class Pool
  def self.redis
    @redis ||= ConnectionPool::Wrapper.new do
      Redis.new host: ENV["REDIS_HOST"],
                ssl: true,
                driver: :hiredis,
                db: 13,
                password: ENV["REDIS_PASSWORD"],
                ssl_params: {
                  ca_file: Rails.root.join("config", "tls", "redis", "ca.crt").to_s,
                  cert: Rails.root.join("config", "tls", "redis", "client.crt").to_s,
                  key: Rails.root.join("config", "tls", "redis", "client.key").to_s,
                  verify_mode: OpenSSL::SSL::VERIFY_PEER
                }
    end
  end
end
