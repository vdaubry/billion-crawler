require "spec_helper"

describe Crawler::UrlFilter do
  describe "valid_url?" do
    it "validates never seen before urls" do
      Crawler::UrlFilter.new(url: "http://www.google.fr").valid_url?.should == true
    end
    
    it "doesn't validates already seen urls" do
      $bloom_filter.insert("http://www.google.fr")
      Crawler::UrlFilter.new(url: "http://www.google.fr").valid_url?.should == false
    end
    
    it "doesn't validates malformed urls" do
      Crawler::UrlFilter.new(url: "/about").valid_url?.should == false
    end
    
    it "doesn't validates urls with other protocol than HTTP or HTTPS" do
      Crawler::UrlFilter.new(url: "ftp://user@ftpserver/path").valid_url?.should == false
    end
  end
end