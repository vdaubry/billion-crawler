# Start sidekiq with : sidekiq -c 40 -q seed -r ./billion_crawler.rb

class SeedWorker
  include Sidekiq::Worker
   sidekiq_options :queue => :seed, :retry => false, :backtrace => true
  
  def perform(url)
    puts "Get #{url}"
    begin
      agent = Mechanize.new
      host = URI.parse(url).host_with_sublevel_domain
      total_time = measure { agent.get(url) }
      $redis.zadd("bc:domains:perf", total_time, host)
    rescue StandardError => e
      puts "Couldn't get #{url} : #{e}"
    end
  end
  
  def measure
    start_time = Time.now.to_f
    
    yield
    
    total_time = Time.now.to_f - start_time
    puts "total time = #{total_time}"
    total_time
  end
end