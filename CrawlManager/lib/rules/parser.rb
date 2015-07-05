module Rules
  class Parser
    def initialize(yaml: "config/rules.yaml")
      @yaml = YAML.load_file(yaml)
    end

    def read
      @yaml.each do |host, conf|
        blacklist = conf["blacklist"].to_json if conf && conf["blacklist"]
        whitelist = conf["whitelist"].to_json if conf && conf["whitelist"]

        Rules::HostConfig.new(host: host).set_rules(blacklist: blacklist, whitelist: whitelist)
      end
    end
  end
end