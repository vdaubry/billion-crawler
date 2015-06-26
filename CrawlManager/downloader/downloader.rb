module Downloader
  class Base
    def initialize
      @page_processor = Downloader::Interfaces::PageProcessor
      @crawler = Downloader::Interfaces::Crawler
      @storage = Downloader::Facades::Storage.new
    end
    
    def download(msg:)
      puts "received msg : #{msg}"
      msg = JSON.parse(msg)
      page = Downloader::WebPage.new(url: msg["url"])
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
        @crawler.crawl(url: link)
      end
    end
  end
end