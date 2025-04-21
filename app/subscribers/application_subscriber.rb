# frozen_string_literal: true

class ApplicationSubscriber

  def run
    Rails.autoloaders.main.eager_load_dir("app/subscribers")

    subscribers = self.class.subclasses.map do |subscriber|
      [ subscriber.channel_name, subscriber ]
    end.to_h

    Pool.redis.subscribe(subscribers.keys) do |on|

      on.subscribe do |channel, subscriptions|
        puts "Subscribed to ##{channel} (#{subscriptions} subscriptions)"
      end

      on.message do |channel, message|
        subscriber = subscribers[channel]
        subscriber.new.receive(message)
      end
    end
  end

  def receive(msg)
    raise NotImplementedError, "Subscribers must implement receive"
  end

  class << self
    attr_reader :channel_name
    def channel(name)
      @channel_name = name
    end
  end

end
