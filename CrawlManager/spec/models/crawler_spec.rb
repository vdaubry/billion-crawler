require "spec_helper"

describe Crawler::Base do
  describe "crawl_next_domain" do
    let(:host) { "google.fr" }
    let(:scrapper_domain) { Crawler::ScrapperDomain.new(host: host) }
    let(:url) { "http://www.google.fr/a.html" }
    
    before(:each) do
      $redis.rpush(Crawler::ScrapperDomain.send(:domains_to_process_key), host)
    end
    
    it "sends url to RabbitMQ" do
      $redis.rpush(scrapper_domain.send(:domain_urls_key), url)
      Crawler::Interfaces::Downloader.any_instance.expects(:download).with({url: url})
      Crawler::Base.new.crawl_next_domain
    end
    
    it "doesn't rate limits domain if there are no url left for this domain " do
      Crawler::Base.new.crawl_next_domain
      $redis.get(scrapper_domain.send(:rate_limit_key)).should be_nil
    end
    
    it "rate limits domain if there are url for this domain " do
      $redis.rpush(scrapper_domain.send(:domain_urls_key), url)
      Crawler::Base.new.crawl_next_domain
      $redis.get(scrapper_domain.send(:rate_limit_key)).should_not be_nil
      $redis.ttl(scrapper_domain.send(:rate_limit_key)).should == 1
    end
    
    it "skips rate limited domains" do
      $redis.setex(scrapper_domain.send(:rate_limit_key), 1, 0)
      Crawler::Base.new.crawl_next_domain
      Crawler::Interfaces::Downloader.any_instance.expects(:download).never
    end
  end
end