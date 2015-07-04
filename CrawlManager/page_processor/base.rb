module PageProcessor
  class Base
    def initialize
      @image_queue = Facades::Queue.new(queue_name: "image_queue")
      @storage = Facades::Storage.new
    end
    
    def process(html:, base_url:) 
      images_url = PageProcessor::WebPage.new(html: html, base_url: base_url).valid_images
      images_url.each do |url|
        image = PageProcessor::Image.new(url: url)
        if image.valid?
          upload(image: image)
          image.known!
        end
      end
    end
    
    def upload(image:)
      @storage.store(key: image.key, data: image.data)
      @storage.store(key: image.thumbnail_key, data: image.thumbnail_data)      

      @image_queue.send(msg: {key: image.key}.to_json)
    end
  end
end