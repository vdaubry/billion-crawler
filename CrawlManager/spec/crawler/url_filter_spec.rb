require "spec_helper"

describe Crawler::UrlFilter do
  describe "valid_url?" do
    it "validates never seen before urls" do
      Crawler::UrlFilter.new(url: Crawler::Url.new(current_url: "http://www.google.fr", parent_url: nil, current_depth: 0)).valid_url?.should == true
    end
    
    it "doesn't validates already seen urls" do
      $bloom_filter.insert("http://www.google.fr")
      Crawler::UrlFilter.new(url: Crawler::Url.new(current_url: "http://www.google.fr", parent_url: nil, current_depth: 0)).valid_url?.should == false
    end
    
    it "doesn't validates malformed urls" do
      Crawler::UrlFilter.new(url: Crawler::Url.new(current_url: "/about", parent_url: nil, current_depth: 0)).valid_url?.should == false
    end
    
    it "doesn't validates urls with other protocol than HTTP or HTTPS" do
      Crawler::UrlFilter.new(url: Crawler::Url.new(current_url: "ftp://user@ftpserver/path", parent_url: nil, current_depth: 0)).valid_url?.should == false
    end
  end
end