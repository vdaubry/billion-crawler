module Crawler
  class Url
    def initialize(current_url:, parent_url:)
      @parent_url = parent_url
      @current_url = current_url
    end

    def to_s
      @current_url
    end

    def parent
      @parent ||= $redis.hgetall(url_key(url: @parent_url))
    end

    def current_depth
      return @current_depth if @current_depth

      parent_host = URI.parse(parent[:current_url]).host_with_sublevel_domain
      current_host = URI.parse(@current_url).host_with_sublevel_domain
      @current_depth = (parent_host != current_host) ? parent[:current_depth] + 1 : parent[:current_depth]
    end

    def delete
      $redis.del(url_key)
    end

    def save
      $redis.hmset(url_key, "parent_url", @parent_url, "current_depth", current_depth)
    end

    private
      def url_key(url:)
        "bc:urls:#{url.hash}"
      end
  end
end