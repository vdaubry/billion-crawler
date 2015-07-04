module Downloader
  class Base
    def initialize
      @page_processor = PageProcessor::Base.new
      @found_url = Crawler::FoundUrl.new
      @storage = Facades::Storage.new
    end
    
    def download(url:)
      $LOG.debug "Downloading #{url}"
      page = Downloader::WebPage.new(url: url)
      process(page: page, base_url: page.base_url)
      extract(page: page)
    end
    
    def process(page:, base_url: )
      @page_processor.process(html: page.data, base_url: base_url)
    end
    
    def extract(page:)
      links = Downloader::LinkExtractor.new(html: page.data, base_url: page.base_url).extract
      links.each do |link|
        $LOG.debug "will crawl #{link}"
        @found_url.crawl(url: link)
      end
    end
  end
end