include VIPS

module Vips
  class InvalidImageError < StandardError; end

  class Base
    attr_writer :reader
    
    def initialize(filepath:, thumb_size:)
      @filepath = filepath
      @thumb_size = thumb_size.to_f
    end
    
    def extension
      @filepath.split(".").last
    end
    
    def dimension
      [reader.x_size, reader.y_size].max
    end
    
    def shrink!(should_sharpen: true)
      jpeg_shrink! if jpg?
      
      integer_dimension = (dimension / shrink_ratio).to_i
      scale = @thumb_size / integer_dimension
      self.reader = reader.shrink(shrink_ratio)
      self.reader = reader.tile_cache(reader.x_size, 1, 30)
      self.reader = reader.affinei_resize(:bicubic, scale)
      
      sharpen! if should_sharpen
      
      #Output to disk or memory
      write
    end
    
    def sharpen!
      mask = [
          [-1, -1,  -1],
          [-1,  32, -1],
          [-1, -1,  -1]
      ]
      self.reader = reader.conv(Mask.new mask, 24, 0 )
    end
    
    private
      def reader
        @reader ||= open(shrink: 1)
      end
    
      def jpeg_shrink!
        #In case of jpeg select nearest shrink ratio (8, 4 or 2) for faster shrinking
        #see https://github.com/jcupitt/ruby-vips/blob/master/examples/thumbnail.rb#L105
        load_shrink = [8, 4, 2].select {|x| x <= shrink_ratio}.first
        open(shrink: load_shrink)
      end
      
      def shrink_ratio
        return 1 if @thumb_size > dimension
        (dimension / @thumb_size).to_i
      end
  end
end