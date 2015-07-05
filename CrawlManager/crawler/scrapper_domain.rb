module Crawler
  class ScrapperDomain
    #Max 1 page per second
    RATE_LIMIT = 1
    
    def initialize(host: nil, url: nil)
      if host.nil?
        @host=URI.parse(url).host_with_sublevel_domain
      else
        @host=host
      end
    end
    
    def self.next_domain_to_process
      Crawler::ScrapperDomain.new(host: $redis.brpoplpush(domains_to_process_key, domains_to_process_key))
    end
    
    def rate_limited?
      $redis.get(rate_limit_key) != nil
    end
    
    def rate_limit!
      $redis.setex(rate_limit_key, RATE_LIMIT, 0).nil?
    end
    
    def next_url_to_process
      url_str = $redis.lpop(domain_urls_key)
      Crawler::Url.find(url: url_str)
    end
    
    def add_url(url:)
      unless $redis.sismember(Crawler::ScrapperDomain.known_domains_key, @host)
        $redis.sadd(Crawler::ScrapperDomain.known_domains_key, @host)
        $redis.rpush(Crawler::ScrapperDomain.domains_to_process_key, @host)
      end
      
      #We use a list of urls instead of a set to reduce memory usage (The bloom filter should garanty urls uniqueness)
      #There might be a race condition here, we tolerate some duplicate in the URL frontier
      $redis.rpush(domain_urls_key, url)
    end
    
    def to_s
      @host
    end
    
    def add_url_to_counter(url:)
      $redis.pfadd(Crawler::ScrapperDomain.urls_counter, url)
    end
    
    def count_urls
      $redis.pfcount(Crawler::ScrapperDomain.urls_counter)
    end
    
    
    private 
    
    def rate_limit_key
      "bc:domains:#{@host}:limit"
    end
    
    def self.domains_to_process_key
      "bc:domains:to.crawl"
    end
    
    def self.known_domains_key
      "bc:domains:known"
    end
    
    def domain_urls_key
      "bc:domains:#{@host}:urls"
    end
    
    def self.urls_counter
      "bc:urls:count"
    end
  end
end