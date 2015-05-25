require "spec_helper"

describe UrlFilter do
  describe "valid_url?" do
    it "validates never seen before urls" do
      UrlFilter.new(url: "http://www.google.fr").valid_url?.should == true
    end
    
    it "doesn't validates already seen urls" do
      $bloom_filter.insert("http://www.google.fr")
      UrlFilter.new(url: "http://www.google.fr").valid_url?.should == false
    end
    
    it "doesn't validates malformed urls" do
      UrlFilter.new(url: "/about").valid_url?.should == false
    end
    
    it "doesn't validates urls with other protocol than HTTP or HTTPS" do
      UrlFilter.new(url: "ftp://user@ftpserver/path").valid_url?.should == false
    end
  end
end