module PageProcessor
  class Image
    attr_reader :src

    def initialize(src:)
      @src = src
      @bloom_filter = BloomFilterFacade.new
    end

    def dimension
      return @dimension if @dimension 

      sizes = FastImage.size(@src)
      @dimension = sizes && sizes.max
    end

    def known?
      @bloom_filter.include?(key: @src)
    end

    def exists?
      @exists ||= Facades::HTTPDownloadFacade.new(url: @url).valid_response?
    end

    def known!
      @bloom_filter.insert(key: @url)
    end
  end
end