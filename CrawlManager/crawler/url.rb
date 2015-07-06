module Crawler
  class Url
    attr_reader :current_depth, :current_url, :parent_url

    def initialize(current_url:, parent_url:, current_depth: 0)
      @parent_url = parent_url
      @current_url = current_url
      @current_depth = current_depth
    end

    def to_s
      current_url
    end

    def compute_current_depth(parent_depth:)
      if parent_url && !parent_url.empty? 
        parent_host = URI.parse(parent_url).host_with_sublevel_domain
        current_host = URI.parse(current_url).host_with_sublevel_domain
        @current_depth = (parent_host != current_host) ? parent_depth + 1 : parent_depth  
      end
    end

    def self.find(url:)
      h = $redis.hgetall(Crawler::Url.url_key(url: url))
      return if h.empty?
      
      current_depth = h["current_depth"].to_i
      Crawler::Url.new(current_url: url, parent_url: h["parent_url"], current_depth: current_depth)
    end
    
    def delete
      $redis.del(Crawler::Url.url_key(url: current_url))
    end

    def save
      $redis.hmset(Crawler::Url.url_key(url: current_url), "parent_url", parent_url, "current_depth", current_depth)
    end

    private
      def self.url_key(url:)
        "bc:urls:#{url}"
      end
  end
end