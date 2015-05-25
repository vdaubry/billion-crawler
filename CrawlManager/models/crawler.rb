class Crawler
  def initialize
    @rabbit_client = RabbitClient.new
  end
  
  def start
    puts "Waiting for url to crawl..."
    loop do
      crawl_next_domain
    end
  end
  
  def crawl_next_domain
    domain = ScrapperDomain.next_domain_to_process
    return if domain.rate_limited?
    
    url = domain.next_url_to_process
    return if url.nil?
    
    puts "Allow crawling URL : #{url} from domain : #{domain.to_s}"
    domain.rate_limit!
    @rabbit_client.send(msg: {url: url}, queue_name: "download_page")
  end

end