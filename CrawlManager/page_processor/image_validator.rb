module PageProcessor
  class ImageValidator
    attr_reader :image

    def initialize(image:)
      @image = image
    end

    def size_too_small?
      image.dimension.nil? || image.dimension < minimum_dimension
    end

    def valid?
      if image.known?
        $LOG.debug "image url already seen : #{image.src}"
        return false
      end

      if size_too_small?
        $LOG.debug "image too small : #{image.src}, dimension : #{image.dimension}"
        return false
      end
      
      true
    end

    private
      def minimum_dimension
        400
      end
  end
end