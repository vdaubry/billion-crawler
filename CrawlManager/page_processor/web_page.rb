module PageProcessor
  class WebPage
    attr_reader :base_url

    def initialize(html:, base_url:)
      @html = Nokogiri::HTML(html)
      @base_url = base_url
    end

    def title
      @html.title
    end

    def images
      images_with_extension = all_images.reject {|src| src.match(/(\.png|\.jpg|\.jpeg)/).nil? }
      images_with_extension.select do |src|
        image = Image.new(src: src)
        PageProcessor::ImageValidator.new(image: image).valid?
      end
    end

    def images_already_seen!
      images.each(&:known!)
    end

    def image_links
      all_image_links.select {|image_link| PageProcessor::ImageLinkValidator.new(image: image_link).valid? }
    end

    def image_links_already_seen!
      all_image_links.each(&:known!)
    end

    private
      def all_images
        @all_images ||= @html.xpath("//img").map do |l|
          SafeUri.join(base_url: @base_url, path: l['src'])
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