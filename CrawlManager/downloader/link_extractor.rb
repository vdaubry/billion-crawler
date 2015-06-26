module Downloader
  class LinkExtractor
    def initialize(html:)
      @html = Nokogiri::HTML(html)
    end
    
    def extract
      @html.xpath("//a").map {|l| l['href']}
    end
  end
end