class DiscoveredUrlListener
  def initialize
    @rabbit_client = RabbitClient.new
    @frontier = UrlFrontier.new
  end
  
  def listen
    puts "Waiting for new urls to be discovered..."
    @rabbit_client.listen(queue_name: "new_urls") do |body|
      url = JSON.parse(body)["url"]
      puts "Found new url : #{url}"
      @frontier.add(url: url)
    end
  end
end