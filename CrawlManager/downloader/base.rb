module Downloader
  class Base
    def initialize
      @page_processor = PageProcessor::Base.new
      @url_frontier = Crawler::UrlFrontier.new
      @storage = Facades::Storage.new
    end
    
    def download(url:, current_depth:)
      Facades::Metrics.count(key: "website.download")
      page = Downloader::WebPage.new(url: url)
      process(page: page, base_url: page.base_url, url: url)
      extract(page: page, url: url, current_depth: current_depth)
    end
    
    def process(page:, base_url:, url:)
      @page_processor.process(html: page.data, base_url: base_url, url: url)
    end
    
    def extract(page:, url:, current_depth:)
      links = Downloader::LinkExtractor.new(html: page.data, base_url: page.base_url).extract
      $LOG.info "Found #{links.count} urls on #{url}"
      links.each do |link|
        $LOG.debug "will crawl #{link}"
        @url_frontier.add(url: link, parent_url: url, current_depth: current_depth)
      end
    end
  end
end