module Rules
  class HostConfig
    def initialize(host:)
      @host = host
    end

    def in_whitelist?(url:)
      whitelist_regex = Regexp.union(whitelist)
      url.match(whitelist_regex) != nil
    end

    def in_blacklist?(url:)
      blacklist_regex = Regexp.union(blacklist)
      url.match(blacklist_regex) != nil
    end

    def url_allowed?(url:)
      unless whitelist.nil?
        return in_whitelist?(url: url)
      end

      unless blacklist.nil?
        return !in_blacklist?(url: url)
      end

      return true
    end

    def set_rules(blacklist:, whitelist:)
      $redis.hmset(host_key, "blacklist", blacklist, "whitelist", whitelist)
    end

    private

      def list_from_redis(key:)
        value = $redis.hget(host_key, key)
        (value.nil? || value.empty?) ? nil : JSON.parse(value)
      end

      def whitelist
        @whitelist ||= list_from_redis(key: "whitelist")
      end

      def blacklist
        @blacklist ||= list_from_redis(key: "blacklist")
      end
      
      def host_key
        "bc:rules:#{@host}"
      end
  end
end