module Downloader
  class Base
    def initialize
      @page_processor = PageProcessor::Base.new
      @url_frontier = Crawler::UrlFrontier.new
      @storage = Facades::Storage.new
    end
    
    def download(url:, current_depth:)
      $LOG.debug "Downloading #{url}"
      page = Downloader::WebPage.new(url: url)
      process(page: page, base_url: page.base_url)
      extract(page: page, url: url, current_depth: current_depth)
    end
    
    def process(page:, base_url: )
      @page_processor.process(html: page.data, base_url: base_url)
    end
    
    def extract(page:, url:, current_depth:)
      links = Downloader::LinkExtractor.new(html: page.data, base_url: page.base_url).extract
      links.each do |link|
        $LOG.debug "will crawl #{link}"
        @url_frontier.add(url: link, parent_url: url, current_depth: current_depth)
      end
    end
  end
end