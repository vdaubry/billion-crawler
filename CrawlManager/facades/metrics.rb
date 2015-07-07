module Facades
  class Metrics
    @@authenticated = false

    def self.client
      return Librato::Metrics if @@authenticated

      Librato::Metrics.authenticate 'vdaubry@gmail.com', '6b8f817c725e85b0b91bf74bfbca7aaa15f3a91a158b5f73f2de86614342ccc5'
      @@authenticated = true
      Librato::Metrics
    end

    def self.count(key:)
      return if ENV["APP_ENV"]=="test"
      puts Benchmark.measure {
        Thread.new { Facades::Metrics.client.submit(key => 1) }
      }
    end
  end
end