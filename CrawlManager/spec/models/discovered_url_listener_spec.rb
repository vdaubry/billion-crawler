require "spec_helper"

describe DiscoveredUrlListener do
  describe "listen" do
    it "pulls urls from RabbitMQ and adds them to redis domain urls list" do
      RabbitClient.any_instance.stubs(:listen).yields({url: "http://google.fr"}.to_json)
      DiscoveredUrlListener.new.listen
      $redis.llen(ScrapperDomain.new(host: "google.fr").send(:domain_urls_key)).should == 1
    end
  end
end