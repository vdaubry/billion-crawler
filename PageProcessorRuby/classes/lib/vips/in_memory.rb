module Vips
  class InMemory < Vips::Base
    def initialize(filepath:, data:, thumb_size:)
      super(filepath: filepath, thumb_size: thumb_size)
      @data = data
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