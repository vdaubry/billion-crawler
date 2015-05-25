require "spec_helper"

describe UrlFrontier do
  describe "add" do
    it "adds valid url to the already seen urls" do
      UrlFrontier.new.add(url: "http://foo.bar")
      ScrapperBloomFilter.new.include?(key: "http://foo.bar").should == true
    end
    
    it "adds not valid url to the already seen urls" do
      UrlFrontier.new.add(url: "/foo")
      ScrapperBloomFilter.new.include?(key: "/foo").should == true
    end
  end
end