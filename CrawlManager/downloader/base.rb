module Downloader
  class Base
    def initialize
      @page_processor = PageProcessor::Base.new
      @found_url = Crawler::FoundUrl.new
      @storage = Facades::Storage.new
    end
    
    def download(url:)
      page = Downloader::WebPage.new(url: url)
      store(page: page)
      send(page: page)
      extract(page: page)
    end
    
    def store(page:)
      @storage.store(key: page.key, data: page.data)
    end
    
    def send(page:)
      @page_processor.process(key: page.key)
    end
    
    def extract(page:)
      links = Downloader::LinkExtractor.new(html: page.data).extract
      links.each do |link|
        @found_url.crawl(url: link)
      end
    end
  end
end