module PageProcessor
  class ImageLink
    attr_reader :href, :src

    def initialize(href:, src:)
      @href = href
      @src = src
      @bloom_filter = BloomFilterFacade.new
    end

    def thumb_valid?
      Facades::HTTPDownloadFacade.new(url: @src).valid_response?
    end

    def known?
      @bloom_filter.include?(key: @href)
    end

    def known!
      @bloom_filter.insert(key: @href)
    end

    def target_html
      Facades::HTTPDownloadFacade.new(url: @href).download
    end

    def base_url
      uri = URI.parse(@href)
      "#{uri.scheme}://#{uri.host}"
    end
  end
end