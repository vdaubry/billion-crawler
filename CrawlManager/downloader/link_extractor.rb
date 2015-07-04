module Downloader
  class LinkExtractor
    def initialize(html:, base_url:)
      @html = Nokogiri::HTML(html)
      @base_url = base_url
    end

    def same_host(url:)
      base_host = URI.parse(@base_url).host_with_sublevel_domain
      url_host = URI.parse(url).host_with_sublevel_domain
      return base_host==url_host
    end

    def url_valid?(url:)
      url && 
      (url =~ /\A#{URI::regexp(['http', 'https'])}\z/) != nil &&
      same_host(url: url)
    end
    
    def extract
      @html.xpath("//a").map do |l| 
        next unless url_valid?(url: l['href'])
        URI.join(@base_url, URI.encode(l['href'])).to_s
      end.compact
    end
  end
end
