module Crawler
  class Url
    attr_reader :current_depth

    def initialize(current_url:, parent_url:, current_depth:)
      @parent_url = parent_url
      @current_url = current_url
      if parent_url
        parent_host = URI.parse(parent_url).host_with_sublevel_domain
        current_host = URI.parse(current_url).host_with_sublevel_domain
        @current_depth = (parent_host != current_host) ? current_depth + 1 : current_depth  
      else
        @current_depth = current_depth
      end
    end

    def to_s
      @current_url
    end

    def self.find(url:)
      h = $redis.hgetall(Crawler::Url.url_key(url: url))
      return if h.empty?
      
      current_depth = h[:current_depth] || 0
      Crawler::Url.new(current_url: url, parent_url: h[:parent_url], current_depth: current_depth)
    end
    
    def delete
      $redis.del(Crawler::Url.url_key(url: @current_url))
    end

    def save
      $redis.hmset(Crawler::Url.url_key(url: @current_url), "parent_url", @parent_url, "current_depth", current_depth)
    end

    private
      def self.url_key(url:)
        "bc:urls:#{url.hash}"
      end
  end
end