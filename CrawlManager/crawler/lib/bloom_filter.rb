module Crawler
  class InvalidKeyError < StandardError; end

  class BloomFilter
    def initialize
    end
    
    def insert(key:)
      raise Crawler::InvalidKeyError, "tried to insert nil or empty value in bloom filter" if key.to_s.empty?
      $bloom_filter.insert(key)
      true
    end
    
    def include?(key:)
      $bloom_filter.include?(key)
    end
  end
end