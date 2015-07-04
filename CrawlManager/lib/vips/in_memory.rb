module Vips
  class InMemory < Vips::Base
    def initialize(filepath:, data:, thumb_size:)
      raise Vips::InvalidImageError, "nil image data" if data.nil?
      
      super(filepath: filepath, thumb_size: thumb_size)
      @data = data
    end

    def jpg?
      return @data[0,2]==0xff.chr + 0xd8.chr
    end
    
    def png?
      return @data[0,2]==0x89.chr + "P"
    end
    
    def open(shrink:)
      self.reader = if jpg?
        JPEGReader.new(@data,
                        :shrink_factor => shrink, 
                        :fail_on_warn => true).read_buffer
      elsif png?
        PNGReader.new(@data).read_buffer
      end
    end
    
    def write
      JPEGWriter.new(reader, {:quality => 50}).to_memory
    end
  end
end