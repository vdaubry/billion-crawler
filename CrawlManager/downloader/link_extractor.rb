module Downloader
  class LinkExtractor
    def initialize(html:, base_url:)
      @html = Nokogiri::HTML(html)
      @base_url = base_url
    end

    def extract
      #TODO : add a uniq (to avoid duplicate links on the same page, text and image for example)
      @html.xpath("//a").map do |l|
        SafeUri.join(base_url: @base_url, path: l['href'])
      end.compact
    end
  end
end
