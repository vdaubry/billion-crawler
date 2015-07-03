module Downloader
  class LinkExtractor
    def initialize(html:, base_url:)
      @html = Nokogiri::HTML(html)
      @base_url = base_url
    end
    
    def extract
      @html.xpath("//a").map { |l| URI.join(@base_url, l['href']).to_s  if l['href'] }.compact
    end
  end
end
