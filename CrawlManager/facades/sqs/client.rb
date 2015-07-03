module Facades::SQS
  class Client
    def initialize(queue_name:)
      return if ENV["APP_ENV"]=="test"
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
    
    def poll
      @poller.poll do |msg|
        yield msg.body
      end
    end
    
    def send(msg:)
      return if ENV["APP_ENV"]=="test"
      @sqs_client.send_message(queue_url: @queue_url,
                                message_body: msg)
    end
  end
end