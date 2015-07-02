module PageProcessor
  class Image
    def initialize(url:)
      @uri = URI.parse(url)
    end
    
    def generate_thumbnail(data:)
      image = Vips::InMemory.new(filepath: "sample.jpg", data: data, thumb_size: 128)
      image.shrink!
    end
    
    def key
      File.basename(@uri.path)
    end
    
    def known?
      image_hash = Digest::MD5.hexdigest(@data)
      BloomFilterFacade.new.include?(key: image_hash)
    end
    
    def download
      http = Net::HTTP.new(@uri.host, @uri.port)
      req = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(req)
      @data = response.body 
      @data
    end
  end
end