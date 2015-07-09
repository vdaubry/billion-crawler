module PageProcessor
  class Image
    def initialize(url:, thumb_size: 300)
      @url = url
      @thumb_size = thumb_size
      @bloom_filter = BloomFilterFacade.new
    end

    def vips
      begin
        @vips ||= Vips::InMemory.new(filepath: key, data: data, thumb_size: @thumb_size)
      rescue Vips::InvalidImageError => e
        $LOG.error e
        nil
      end
    end
    
    def thumbnail_key
      name = key.split(".").first
      ext = key.split(".").last
      "#{name}_300x300.#{ext}"
    end

    def thumbnail_data
      return if vips.nil?
      @thumb ||= vips.shrink!
    end
    
    def key
      inverted_timestamp = Time.now.to_i.to_s.reverse
      path = File.basename(URI.parse(@url).path)
      "#{inverted_timestamp}_#{path}"
    end
    
    def data
      @data ||= Facades::HTTPDownloadFacade.new(url: @url).download
    end

    def dimension
      return @dimension if @dimension 

      sizes = FastImage.size(@url) 
      @dimension = sizes && sizes.max
      @dimension
    end

    def known?
      @bloom_filter.include?(key: @url)
    end

    def exists?
      @exists ||= Facades::HTTPDownloadFacade.new(url: @url).head
    end

    def known!
      @bloom_filter.insert(key: @url)
    end
  end
end