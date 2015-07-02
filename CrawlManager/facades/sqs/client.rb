module Facades::SQS
  class Client
    def initialize(queue_name:)
      unless ENV["APP_ENV"]=="test"
        Aws.config.update({
          access_key_id: ENV['ACCESS_KEY_ID'],
          secret_access_key: ENV['SECRET_ACCESS_KEY'],
          region: 'us-east-1'
        })
        @sqs_client = Aws::SQS::Client.new
        resp = @sqs_client.get_queue_url(queue_name: queue_name)
        @queue_url = resp.queue_url
        @poller = Aws::SQS::QueuePoller.new(queue_url: @queue_url,
                                            max_number_of_messages: 10,
                                            wait_time_seconds: 0.1)
        @poller.instance_variable_set(:@queue_url, resp.queue_url)
      end
    end
    
    def poll
      @poller.poll do |msg|
        #begin
          yield msg.body
        # rescue StandardError => e
        #   puts "unexpected error : #{e}"
        #   throw :skip_delete #re-process message later
        # end
      end
    end
    
    def send(msg:)
      @sqs_client.send_message(queue_url: @queue_url,
                                message_body: msg)
    end
  end
end