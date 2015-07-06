module Downloader
  class LinkExtractor
    def initialize(html:, base_url:)
      @html = Nokogiri::HTML(html)
      @base_url = base_url
    end

    def extract
      #TODO : add a uniq (to avoid duplicate links on the same page, text and image for example)
      @html.xpath("//a").map do |l| 
        begin
          URI.join(@base_url, URI.encode(l['href'])).to_s if l['href']
        rescue URI::InvalidURIError => e
          $LOG.error e
          nil
        end
      end.compact
    end
  end
end
