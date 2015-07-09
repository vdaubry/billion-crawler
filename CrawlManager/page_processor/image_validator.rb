module PageProcessor
  class ImageValidator
    attr_reader :image

    MINIMUM_DIMENSION = 350

    def initialize(image:)
      @image = image
    end

    def size_too_small?
      image.dimension.nil? || image.dimension < MINIMUM_DIMENSION
    end

    def valid?
      if image.known?
        $LOG.debug "image url already seen : #{@url}"
        return false
      end

      if size_too_small?
        $LOG.debug "image too small : #{@url}, dimension : #{dimension}"
        return false
      end
      
      return true
    end
  end
end