require_relative "base"

module Vips
  class File < Vips::Base
    def initialize(filepath:, thumb_size:, thumbpath:)
      super(filepath: filepath, thumb_size: thumb_size)
      @thumbpath = thumbpath
    end
    
    def open(shrink:)
      self.reader = if jpg?
        Image.jpeg(@filepath, 
                  :shrink_factor => shrink,
                  :sequential => true)
      elsif png?
        Image.png(@filepath, 
                  :sequential => true)
      end
    end
    
    def write
      JPEGWriter.new(@reader, :quality => 50).write(@thumbpath)
    end
  end
end