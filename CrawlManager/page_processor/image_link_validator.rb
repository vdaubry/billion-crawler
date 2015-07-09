module PageProcessor
  class ImageLinkValidator
    def initialize(image_link:)
      @image_link = image_link
    end

    def valid?
      if @image_link.known?
        $LOG.debug "image_link url already seen : #{image_link.href}"
        return false
      end

      if !@image_link.thumb_valid?
        $LOG.debug "image_link thumb image invalid : #{image_link.src}"
        return false
      end

      return true
    end
  end
end