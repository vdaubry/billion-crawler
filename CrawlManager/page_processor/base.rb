module PageProcessor
  class Base
    def initialize
      @image_queue = Facades::Queue.new(queue_name: "image_queue")
      @storage = Facades::Storage.new
    end
    
    def process(html:, base_url:)
      @page = PageProcessor::WebPage.new(html: html, base_url: base_url)
      images_url = @page.valid_images
      images_url.each do |url|
        $LOG.debug "Process image : #{url}"
        image = PageProcessor::Image.new(url: url)
        if image.valid?
          upload(image: image, base_url: base_url)
          image.known!
        end
      end
    end
    
    def upload(image:, base_url:)
      $LOG.debug "upload image : #{image.key} , size : #{image.data.size}, dimension : #{image.dimension}"
      @storage.store(key: image.key, data: image.data)
      $LOG.debug "upload image : #{image.thumbnail_key} , size : #{image.thumbnail_data.size}"
      @storage.store(key: image.thumbnail_key, data: image.thumbnail_data)      

      msg = {key: image.key, host: base_url, title: @page.title}.to_json
      $LOG.debug "send to queue : #{msg}"
      @image_queue.send(msg: msg)
    end
  end
end