class UrlFrontier
  def add(url:)
    if UrlFilter.new(url: url).valid_url?
      ScrapperDomain.new(url: url).add_url(url: url)
    end
    
    ScrapperBloomFilter.new.insert(key: url)
  end
end