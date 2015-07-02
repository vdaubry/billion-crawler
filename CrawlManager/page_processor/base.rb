module PageProcessor
  class Base
    def initialize
      @image_queue = Facades::Queue.new(queue_name: "image_queue")
      @storage = Facades::Storage.new
    end
    
    def process(key:)
      download_images(key: key)
      delete(key: key)
    end
    
    def download_images(key:)
      html = @storage.download(key: key)
      images_url = PageProcessor::WebPage.new(html: html).valid_images
      images_url.each do |url|
        img = PageProcessor::Image.new(url: url)
        data = img.download
        upload(key: img.key, data: data) unless img.known?
      end
    end
    
    def upload(key:, data:)
      @storage.store(key: key, data: data)
      @image_queue.send(msg: {key: key}.to_json)
    end
    
    def delete(key:)
      @storage.delete(key: key)
    end
  end
end