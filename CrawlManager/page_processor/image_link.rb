module PageProcessor
  class ImageLink < PageProcessor::Image
    attr_reader :href

    def initialize(src:, href:)
      super(src: src)
      @href = href
    end

    def base_url
      uri = URI.parse(@href)
      "#{uri.scheme}://#{uri.host}"
    end

    def to_json
      {
        "src": @src,
        "href": @href,
        "scrapped_at": Time.now.to_s
      }
    end
  end
end