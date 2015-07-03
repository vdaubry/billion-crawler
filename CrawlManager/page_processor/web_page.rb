module PageProcessor
  class WebPage
    def initialize(html:, base_url:)
      @html = Nokogiri::HTML(html)
      @base_url = base_url
      @bloom_filter = BloomFilterFacade.new
    end
    
    def all_images
      @html.xpath("//img").map {|l| URI.join(@base_url, l['src']).to_s  if l['src'] }.compact
    end
    
    def filter_by_extensions(images:)
      images.reject {|src| src.match(/(\.png|\.jpg|\.jpeg)/).nil? }
    end
    
    #Exclude images based on unique url
    def exclude_already_seen(images:)
      images.reject {|src| @bloom_filter.include?(key: src) }
    end
    
    # def exclude_small_images(images:)
    #   images.reject {|src| FastImage.size(src) }
    # end
    
    def valid_images
      valid_images = filter_by_extensions(images: all_images)
      exclude_already_seen(images: valid_images)
      #TODO : See if we get much faster download by activating it
      #valid_images = valid_images.exclude_small_images(images)
    end
  end
end