require "spec_helper"

describe Crawler::ScrapperDomain do
  let(:host) { "google.fr" }
  let(:scrapper_domain) { Crawler::ScrapperDomain.new(host: host) }
  
  describe "new" do
    it "initialize a domain from a host" do
      domain = Crawler::ScrapperDomain.new(host: host)
      domain.instance_eval { @host }.should == host
    end
    
    it "initialize a domain from an url" do
      domain = Crawler::ScrapperDomain.new(url: "http://www.google.fr/about.html")
      domain.instance_eval { @host }.should == host
    end
  end
    
  describe "add_url" do
    it "adds new domain to domain list" do
      scrapper_domain.add_url(url: "http://google.fr/a.html")
      
      $redis.smembers(Crawler::ScrapperDomain.send(:known_domains_key)).should == ["google.fr"]
      $redis.lrange(Crawler::ScrapperDomain.send(:domains_to_process_key), 0, 2).should == ["google.fr"]
    end
    
    it "doesn't add existing domain to domain list" do
      $redis.rpush(Crawler::ScrapperDomain.send(:domains_to_process_key), host)
      $redis.sadd(Crawler::ScrapperDomain.send(:known_domains_key), host)
      
      scrapper_domain.add_url(url: "http://google.fr/a.html")
      
      $redis.smembers(Crawler::ScrapperDomain.send(:known_domains_key)).should == ["google.fr"]
      $redis.lrange(Crawler::ScrapperDomain.send(:domains_to_process_key), 0, 2).should == ["google.fr"]
    end
    
    it "adds url to domain urls list" do
      scrapper_domain.add_url(url: "http://google.fr/a.html")
      
      $redis.lrange(scrapper_domain.send(:domain_urls_key), 0, 2).should == ["http://google.fr/a.html"]
    end
  end
end