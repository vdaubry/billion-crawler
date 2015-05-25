class UrlFrontier
  def add(url:)
    url_filter = UrlFilter.new(url: url)
      
    if url_filter.valid_url?
      domain = ScrapperDomain.new(url: url)
      domain.add_url(url: url)
    end
    
    ScrapperBloomFilter.new.insert(key: url)
  end
end