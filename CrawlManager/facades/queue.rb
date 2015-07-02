module Facades
  class Queue
    def initialize(queue_name:)
      @queue = Facades::SQS::Client.new(queue_name: queue_name)
    end
    
    def poll
      @queue.poll do |msg|
        yield msg
      end
    end
    
    def send(msg:)
      puts "send #{msg}"
      @queue.send(msg: msg)
    end
  end
end