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
      image_links = @page.valid_image_links
      $LOG.info "Found #{image_links.count} image_links on #{url}"

      image_links.each do |image_link|
        Facades::Metrics.count(key: "image.process")
        @image_target_page = PageProcessor::WebPage.new(html: image_link.target_html, base_url: image_link.base_url)

        if @image_target_page.valid_images.count > 0
          @image_target_page.images_already_seen!
          send(thumb_url: image_link.src, images_url: image_link.href)
        end

      end
      #set images links url as already seen
      @page.image_links_already_seen!

      @frontier.done(url: url)
      Facades::Metrics.count(key: "website.process")
    end

    def send(thumb_url:, image_url:)
      msg = {thumb_url: thumb_url, image_url: image_url, title: @page.title}.to_json
      $LOG.debug "send to queue : #{msg}"
      @image_queue.send(msg: msg)
    end
  end
end