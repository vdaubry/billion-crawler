module Crawler
  class UrlFrontier
    def add(url:)
      if Crawler::UrlFilter.new(url: url).valid_url?
        Crawler::ScrapperDomain.new(url: url).add_url(url: url)
      end
      
      BloomFilterFacade.new.insert(key: url)
    end
  end
end