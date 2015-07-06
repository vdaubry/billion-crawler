module Crawler  
  class UrlFilter
    def initialize(url:)
      @max_depth = Crawler::Configuration.get(property_name: "max_depth")
      @url = url
    end
    
    def valid_url?
      if malformed?
        $LOG.debug "Cannot add url to the frontier : #{@url} is not a valid url"
        return false
      end
      
      if already_seen?
        $LOG.debug "Cannot add url to the frontier : #{@url} has already been added to the frontier"
        return false
      end

      if not_allowed?
        $LOG.debug "Cannot add url to the frontier : #{@url} was blacklisted"
        return false
      end

      if too_deep?
        $LOG.debug "Cannot add url to the frontier : #{@url} was too deep (max depth = @max_depth)"
        return false
      end
      
      return true
    end
    
    def malformed?
      (@url.to_s =~ /\A#{URI::regexp(['http', 'https'])}\z/).nil?
    end
    
    def already_seen?
      BloomFilterFacade.new.include?(key: @url.to_s)
    end

    def not_allowed?
      !Rules::HostConfig.new(host: URI.parse(@url.to_s).host_with_sublevel_domain).url_allowed?(url: @url.to_s)
    end

    def too_deep?
      @url.current_depth > @max_depth
    end
  end
end