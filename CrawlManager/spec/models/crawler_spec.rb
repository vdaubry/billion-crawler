require "spec_helper"

describe Crawler do
  describe "crawl_next_domain" do
    let(:host) { "google.fr" }
    let(:scrapper_domain) { ScrapperDomain.new(host: host) }
    let(:url) { "http://www.google.fr/a.html" }
    
    before(:each) do
      $redis.rpush(ScrapperDomain.send(:domains_to_process_key), host)
    end
    
    it "adds jobs from domain queue in redis" do
      $redis.rpush(scrapper_domain.send(:domain_urls_key), url)
      expect {
        Crawler.new.crawl_next_domain
        }.to change{FetchUrlWorker.jobs.count}.by(1)
        FetchUrlWorker.jobs.first["args"].should == [url]
    end
    
    it "rate limits domain" do
      Crawler.new.crawl_next_domain
      $redis.get(scrapper_domain.send(:rate_limit_key)).should_not be_nil
      $redis.ttl(scrapper_domain.send(:rate_limit_key)).should == 1
    end
    
    it "skips rate limited domains" do
      $redis.setex(scrapper_domain.send(:rate_limit_key), 1, 0)
      expect {
        Crawler.new.crawl_next_domain
        }.to change{FetchUrlWorker.jobs.count}.by(0)
    end
  end
end