module Crawler
  class Base
    def initialize
      @downloader = Downloader::Base.new
    end
    
    def start
      $LOG.debug "Waiting for url to crawl..."
      loop do
        crawl_next_domain
      end
    end
    
    def crawl_next_domain
      domain = Crawler::ScrapperDomain.next_domain_to_process
      return if domain.rate_limited?
      
      url = domain.next_url_to_process
      return if url.nil?
      
      $LOG.debug "Allow crawling URL : #{url} from domain : #{domain.to_s}"
      domain.rate_limit!
      @downloader.download(url: url)
    end
  end
end