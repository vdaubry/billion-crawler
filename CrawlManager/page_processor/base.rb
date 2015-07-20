module PageProcessor
  class Base
    def initialize
      @image_queue = Facades::Queue.new(queue_name: "image_queue")
      @storage = Facades::Storage.new
      @frontier = Crawler::UrlFrontier.new
    end

    def process(html:, base_url:, url:)
      $LOG.info "Process page : #{url}"
      @page = PageProcessor::WebPage.new(html: html, base_url: base_url, url: url)

      #TODO: DRY code to deal with images and image_links the same way
      image_links = @page.image_links
      $LOG.info "Found #{image_links.count} image_links on #{url}"

      image_links.each do |image_link|
        Facades::Metrics.count(key: "image.process")
        send(website_url: @page.base_url, post_name: @page.title, post_url: @page.url, image: image_link)
      end
      #set images links url as already seen
      @page.image_links_already_seen!

      images = @page.images
      $LOG.info "Found #{images.count} direct images on #{url}"

      images.each do |image|
        Facades::Metrics.count(key: "image.process")
        send(website_url: @page.base_url, post_name: @page.title, post_url: @page.url, image: image)
      end
      #set images links url as already seen
      @page.images_already_seen!

      @frontier.done(url: url)
      Facades::Metrics.count(key: "website.process")
    end

    def send(website_url:, post_name:, post_url:, image:)
      msg = ImageMessageBuilder.new(website_url, post_name, post_url, image).to_json
      $LOG.debug "send to queue : #{msg}"
      @image_queue.send(msg: msg)
    end
  end
end