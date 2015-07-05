module Crawler
  class UrlFrontier
    def add(current_url:, parent_url:)
      url = Crawler::Url.new(current_url: current_url, parent_url: parent_url)

      if Crawler::UrlFilter.new(url: url).valid_url?
        url.save
        Crawler::ScrapperDomain.new(url: url.to_s).add_url(url: url.to_s)
      end
      
      BloomFilterFacade.new.insert(key: url.to_s)
    end
  end
end