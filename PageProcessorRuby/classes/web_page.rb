class WebPage
  def initialize(html:)
    @html = Nokogiri::HTML(html)
  end
  
  def images
    @html.xpath("//img").map {|l| l['src']}.compact
  end
  
  def filter_by_extensions(images)
    images.reject {|src| src.match(/(\.png|\.jpg|\.jpeg)/).nil? }
  end
  
  def exclude_already_seen(images)
    images.reject {|src| ProcessorBloomFilter.new.include?(key: src) }
  end
  
  def exclude_small_images(images)
    images.reject {|src| FastImage.size(src) }
  end
  
  def valid_images
    valid_images = images.filter_by_extensions(images)
    valid_images.exclude_already_seen(images)
    #TODO : See if we get much faster download by activating it
    #valid_images = valid_images.exclude_small_images(images)
  end
end