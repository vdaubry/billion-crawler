require "spec_helper"

describe "FetchUrlWorker" do
  let(:host) { "google.fr" }
  let(:scrapper_domain) { ScrapperDomain.new(host: host) }
  
  describe "perform", vcr: true do
    it "adds new urls to redis" do
      FetchUrlWorker.new.perform("http://www.google.fr")
      $redis.lrange(scrapper_domain.send(:domain_urls_key), 0, 2).should == ["http://www.google.fr/imghp?hl=fr&tab=wi", "http://maps.google.fr/maps?hl=fr&tab=wl", "http://news.google.fr/nwshp?hl=fr&tab=wn"]
    end
    
    it "doesn't add already seen urls to redis" do
      $bloom_filter.insert("http://www.google.fr/imghp?hl=fr&tab=wi")
      
      FetchUrlWorker.new.perform("http://www.google.fr")
      
      $redis.lrange(scrapper_domain.send(:domain_urls_key), 0, 2).should == ["http://maps.google.fr/maps?hl=fr&tab=wl", "http://news.google.fr/nwshp?hl=fr&tab=wn", "http://www.google.fr/intl/fr/options/"]
    end
  end
end