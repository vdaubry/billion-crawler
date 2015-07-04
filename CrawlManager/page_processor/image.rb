module PageProcessor
  class Image
    MINIMUM_DIMENSION = 300

    def initialize(url:, thumb_size: 300)
      @url = url
      @thumb_size = thumb_size
      @bloom_filter = BloomFilterFacade.new
    end

    def vips
      @vips ||= Vips::InMemory.new(filepath: key, data: data, thumb_size: @thumb_size)
    end
    
    def thumbnail_key
      name = key.split(".").first
      ext = key.split(".").last
      "#{name}_300x300.#{ext}"
    end

    def thumbnail_data
      @thumb ||= vips.shrink!
    end
    
    def key
      inverted_timestamp = Time.now.to_i.to_s.reverse
      path = File.basename(URI.parse(@url).path)
      "#{inverted_timestamp}_#{path}"
    end
    
    def data
      @data ||= Mechanize.new.get(@url).body
    end

    def hash
      Digest::MD5.hexdigest(data)
    end

    #exclude 2 similar images with different urls
    def known?
      @bloom_filter.include?(key: hash)
    end

    def known!
      @bloom_filter.insert(key: hash)
    end

    def size_too_small?
      vips.dimension < MINIMUM_DIMENSION
    end

    def valid?
      not known? and not size_too_small?
    end
  end
end