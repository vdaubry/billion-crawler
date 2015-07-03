module PageProcessor
  class Image
    def initialize(url:, thumb_size: 300)
      @uri = URI.parse(url)
      @thumb_size = thumb_size
      @bloom_filter = BloomFilterFacade.new
    end
    
    def thumbnail_key
      name = key.split(".").first
      ext = key.split(".").last
      "#{name}_300x300.#{ext}"
    end

    def thumbnail_data
      return @thumb unless @thumb.nil?

      @thumb = Vips::InMemory.new(filepath: key, data: data, thumb_size: @thumb_size)
      @thumb.shrink!
    end
    
    def key
      inverted_timestamp = Time.now.to_i.to_s.reverse
      path = File.basename(@uri.path)
      "#{inverted_timestamp}_#{path}"
    end
    
    def data
      return @data unless @data.nil?

      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl = true if @uri.scheme == "https"
      req = Net::HTTP::Get.new(@uri.request_uri)
      response = http.request(req)
      @data = response.body 
      @data
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
  end
end