module PageProcessor
  class WebPage
    def initialize(html:, base_url:)
      @html = Nokogiri::HTML(html)
      @base_url = base_url
    end

    def title
      @html.title
    end
    
    def all_images
      @all_images ||= @html.xpath("//img").map {|l| SafeUri.join(base_url: @base_url, path: l['src']).to_s }.compact
    end
    
    def images
      all_images.reject {|src| src.match(/(\.png|\.jpg|\.jpeg)/).nil? }
    end

    def valid_images
      images.map do |image| 
        image if ImageValidator(image: image).valid?
      end.compact
    end

    def image_links_already_seen!
      all_image_links.each(&:known!)
    end

    def images_already_seen!
      images.each(&:known!)
    end

    def valid_image_links
      all_image_links.map do |image_link|
       image_link if ImageLinkValidator.new(image_link: image_link).valid?
      end.compact
    end

    def all_image_links
      @all_image_links ||= @html.xpath("//a/img").map do |l|
        src = SafeUri.join(base_url: @base_url, path: l['src']).to_s
        href = SafeUri.join(base_url: @base_url, path: l.parent['href']).to_s
        PageProcessor::ImageLink.new(href: href, src: src) if href && src
      end.compact
    end
  end
end