class Crawler
  
  def start
    loop do
      crawl_next_domain
    end
  end
  
  def crawl_next_domain
    domain = ScrapperDomain.next_domain_to_process
    return if domain.rate_limited?
    
    puts "Crawling #{domain.to_s}"
    domain.rate_limit!
    url = domain.next_url_to_process
    puts "Processing #{url}"
    FetchUrlWorker.perform_async(url) unless url.nil?
  end
  
  def load_root_urls(urls:)
    urls.each do |url|
      domain = ScrapperDomain.new(host: URI.parse(url).host_with_sublevel_domain)
      domain.add_url(url: url)
    end
  end
end