module Crawler
  class UrlFrontier
    def add(url:, parent_url:, current_depth:)
      url = Crawler::Url.new(current_url: url, parent_url: parent_url)
      url.compute_current_depth(parent_depth: current_depth)

      if Crawler::UrlFilter.new(url: url).valid_url?
        url.save
        Crawler::ScrapperDomain.new(url: url.to_s).add_url(url: url.to_s)
      end
      
      BloomFilterFacade.new.insert(key: url.to_s)
    end
  end
end