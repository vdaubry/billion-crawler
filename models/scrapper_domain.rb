class ScrapperDomain
  #Max 1 page per second
  RATE_LIMIT = 1
  
  def initialize(host:)
    @host=host
  end
  
  def self.next_domain_to_process
    ScrapperDomain.new(host: $redis.brpoplpush(domains_to_process_key, domains_to_process_key))
  end
  
  def rate_limited?
    $redis.get(rate_limit_key) != nil
  end
  
  def rate_limit!
    $redis.setex(rate_limit_key, RATE_LIMIT, 0).nil?
  end
  
  def next_url_to_process
    $redis.lpop(domain_urls_key)
  end
  
  def add_url(url:)
    unless $redis.sismember(ScrapperDomain.known_domains_key, @host)
      $redis.sadd(ScrapperDomain.known_domains_key, @host)
      $redis.rpush(ScrapperDomain.domains_to_process_key, @host)
    end
    
    #We use a list of urls instead of a set to reduce memory usage (The bloom filter should garanty urls uniqueness)
    $redis.rpush(domain_urls_key, url)
  end
  
  def to_s
    @host
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
end