module Processor
  class InvalidKeyError < StandardError; end

  class BloomFilter
    def insert(key:)
      raise Processor::InvalidKeyError, "tried to insert nil or empty value in bloom filter" if key.to_s.empty?
      $bloom_filter.insert(key)
      true
    end
    
    def include?(key:)
      $bloom_filter.include?(key)
    end
  end
end