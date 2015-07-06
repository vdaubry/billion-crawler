class BloomFilterFacade
  def initialize
  end
  
  def insert(key:)
    unless key.to_s.empty?
      $bloom_filter.insert(key)
    else
      $LOG.error "tried to insert nil or empty value in bloom filter"
    end
    
    true
  end
  
  def include?(key:)
    $bloom_filter.include?(key)
  end
end