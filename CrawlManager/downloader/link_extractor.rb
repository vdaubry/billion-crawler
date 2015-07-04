module Downloader
  class LinkExtractor
    def initialize(html:, base_url:)
      @html = Nokogiri::HTML(html)
      @base_url = base_url
    end
    
    def extract
      @html.xpath("//a").map do |l| 
        next if l['href'].nil?
        next if l['href'] =~ /\A#{URI::regexp(['http', 'https'])}\z/
        URI.join(@base_url, URI.encode(l['href'])).to_s
      end.compact
    end
  end
end
