module PageProcessor
  class Base
    def initialize
      @image_queue = Facades::Queue.new(queue_name: "image_queue")
      @storage = Facades::Storage.new
      @frontier = Crawler::UrlFrontier.new
    end
    
    def process(html:, base_url:, url:)
      $LOG.info "Process page : #{url}"
      @page = PageProcessor::WebPage.new(html: html, base_url: base_url)
      images_url = @page.valid_images
      $LOG.info "Found #{images_url.count} images on #{url}"
      images_url.each do |url|
        Facades::Metrics.count(key: "image.process")
        image = PageProcessor::Image.new(url: url)
        if image.valid?
          $LOG.info "Process valid image : #{url}"
          upload(image: image, base_url: base_url)
        end
        image.known!
      end
      #set images url as already seen
      @page.already_seen!

      @frontier.done(url: url)
      Facades::Metrics.count(key: "website.process")
    end
    
    def upload(image:, base_url:)
      $LOG.info "upload image : #{image.key} , size : #{image.data.size}, dimension : #{image.dimension}"
      @storage.store(key: image.key, data: image.data)
      @storage.store(key: image.thumbnail_key, data: image.thumbnail_data)      

      msg = {key: image.key, host: base_url, title: @page.title}.to_json
      $LOG.debug "send to queue : #{msg}"
      @image_queue.send(msg: msg)
    end
  end
end