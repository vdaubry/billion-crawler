module Crawler
  class FoundUrl

    def initialize
      @frontier = UrlFrontier.new
    end

    def crawl(url:)
      @frontier.add(url: url)
    end

  end
end