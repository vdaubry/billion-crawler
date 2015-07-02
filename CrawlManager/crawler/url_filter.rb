module Crawler  
  class UrlFilter
    def initialize(url:)
      @url = url
    end
    
    def valid_url?
      if malformed?
        puts "Cannot add url to the frontier : #{@url} is not a valid url"
        return false
      end
      
      if already_seen?
        puts "Cannot add url to the frontier : #{@url} has already been crawled"
        return false
      end
      
      return true
    end
    
    def malformed?
      (@url =~ /\A#{URI::regexp(['http', 'https'])}\z/).nil?
    end
    
    def already_seen?
      BloomFilterFacade.new.include?(key: @url)
    end
  end
end