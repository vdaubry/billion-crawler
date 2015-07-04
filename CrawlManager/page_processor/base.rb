module PageProcessor
  class Base
    def initialize
      @image_queue = Facades::Queue.new(queue_name: "image_queue")
      @storage = Facades::Storage.new
    end
    
    def process(html:, base_url:) 
      images_url = PageProcessor::WebPage.new(html: html, base_url: base_url).valid_images
      images_url.each do |url|
        puts "Process image : #{url}"
        image = PageProcessor::Image.new(url: url)
        if image.valid?
          upload(image: image)
          image.known!
        end
      end
    end
    
    def upload(image:)
      puts "upload image : #{image.key} , size : #{image.data.size}, dimension : #{image.dimension}"
      @storage.store(key: image.key, data: image.data)
      puts "upload image : #{image.thumbnail_key} , size : #{image.thumbnail_data.size}"
      @storage.store(key: image.thumbnail_key, data: image.thumbnail_data)      

      msg = {key: image.key}.to_json
      puts "send to queue : #{msg}"
      @image_queue.send(msg: msg)
    end
  end
end