module PageProcessor
  class WebPage
    attr_reader :base_url, :url

    def initialize(html:, base_url:, url:)
      @url = url
      @html = Nokogiri::HTML(html)
      @base_url = base_url
    end

    def title
      @html.title
    end

    def images
      all_images.select {|image|  PageProcessor::ImageValidator.new(image: image).valid? }
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
        return @all_images  if @all_images

        images_without_link = @html.xpath("//img").select {|l| l.parent.name!="a"}
        @all_images = images_without_link.map do |l|
          uri = SafeUri.join(base_url: @base_url, path: l['src'])
          PageProcessor::Image.new(src: uri) if uri
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