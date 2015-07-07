module PageProcessor
  class Image
    MINIMUM_DIMENSION = 300

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
      sizes = FastImage.size(@url) 
      sizes && sizes.max

      # TODO : Test if overall perfs degrade when downloading full image to get dimension 
      # return if vips.nil?
      # vips.dimension
    end

    def hash
      Digest::MD5.hexdigest(data)
    end

    #exclude 2 similar images with different urls
    def known?
      @bloom_filter.include?(key: hash)
    end

    def known!
      @bloom_filter.insert(key: hash) if data
    end

    def size_too_small?
      dimension.nil? || MINIMUM_DIMENSION.nil? || dimension < MINIMUM_DIMENSION
    end

    def valid?
      #Check remote image size before downloading
      if size_too_small?
        $LOG.debug "image too small : #{@url}, dimension : #{dimension}"
        return false
      end

      if data.nil? || vips.nil? || !vips.valid?
        $LOG.debug "image doesn't exist : #{@url}"
        return false
      end      

      

      if known?
        $LOG.debug "image already seen : #{@url}"
        return false
      end
      
      return true
    end
  end
end