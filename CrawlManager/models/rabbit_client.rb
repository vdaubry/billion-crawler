class RabbitClient
  def initialize
    unless ENV["APP_ENV"]=="test"
      timeout = ENV["APP_ENV"]=="production" ? 1 : 100
      conn = Bunny.new(hostname: ENV["RABBITMQ_HOST"], continuation_timeout: timeout)
      conn.start
      @ch = conn.create_channel
      #@ch.prefetch(100)
    end
  end
  
  def send(msg:, queue_name:)
    unless ENV["APP_ENV"]=="test"
      if msg.nil?
        raise StandardError("tried to send a nil message to RabbitMQ")
      end
      q = @ch.queue(queue_name, :durable => true)
      q.publish(msg.to_json, :persistent => true, :content_type => "application/json")
    end
  end
  
  def listen(queue_name:)
    unless ENV["APP_ENV"]=="test"
      q = @ch.queue(queue_name, :durable => true)
      q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        yield body
        @ch.ack(delivery_info.delivery_tag)
      end
    end
  end
  
  def purge(queue_name:)
    unless ENV["APP_ENV"]=="test"
      q = @ch.queue(queue_name, :durable => true)
      q.purge
    end
  end
end
