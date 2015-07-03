require "spec_helper"

describe Crawler::UrlFrontier do
  describe "add" do
    it "adds valid url to the already seen urls" do
      Crawler::UrlFrontier.new.add(url: "http://foo.bar")
      BloomFilterFacade.new.include?(key: "http://foo.bar").should == true
    end
    
    it "adds not valid url to the already seen urls" do
      Crawler::UrlFrontier.new.add(url: "/foo")
      BloomFilterFacade.new.include?(key: "/foo").should == true
    end
  end
end