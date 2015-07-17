module PageProcessor
  class ImageLinkValidator < PageProcessor::ImageValidator

    private
      def minimum_dimension
        250
      end
  end
end