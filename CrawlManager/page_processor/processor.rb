module Processor
  class Base
    def initialize
      @image_queue = Processor::Facades::Queue.new(queue_name: "image_queue")
      @storage = Processor::Facades::Storage.new
    end
    
    def process(msg:)
      msg = JSON.parse(msg)
      key = msg["key"]
      
      download_images(key: key)
      delete(key: key)
    end
    
    def download_images(key:)
      html = @storage.download(key: key)
      images_url = Processor::WebPage.new(html: html).valid_images
      images_url.each do |url|
        img = Processor::Image.new(url: url)
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