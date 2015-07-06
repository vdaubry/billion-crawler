require "spec_helper"

describe Crawler::Url do
  describe "compute_current_depth" do
    context "root url" do
      let(:url) { Crawler::Url.new(current_url: "http://www.google.com", parent_url: nil) }

      it "sets current_depth to 0" do
        url.compute_current_depth(parent_depth: 0)
        url.current_depth.should == 0
      end
    end

    context "child url on same host" do
      let(:url) { Crawler::Url.new(current_url: "http://www.google.com/something", parent_url: "http://www.google.com/") }

      it "sets current_depth to 0" do
        url.compute_current_depth(parent_depth: 0)
        url.current_depth.should == 0
      end
    end

    context "child url on different host from root host" do
      let(:url) { Crawler::Url.new(current_url: "http://www.other.com/", parent_url: "http://www.google.com/") }

      it "sets current_depth to 0" do
        url.compute_current_depth(parent_depth: 0)
        url.current_depth.should == 1
      end
    end

    context "child url on different host from different host" do
      let(:url) { Crawler::Url.new(current_url: "http://www.other.com/", parent_url: "http://www.google.com/") }

      it "sets current_depth to 0" do
        url.compute_current_depth(parent_depth: 1)
        url.current_depth.should == 2
      end
    end
  end

  describe "find" do
    context "url exists" do
      it "returns saved root url" do
        Crawler::Url.new(current_url: "http://www.google.com", parent_url: nil, current_depth: 0).save

        url = Crawler::Url.find(url: "http://www.google.com")
        url.to_s.should == "http://www.google.com"
        url.parent_url.should == ""
        url.current_depth.should == 0
      end

      it "returns saved child url" do
        Crawler::Url.new(current_url: "http://www.google.com/path", parent_url: "http://www.other.com", current_depth: 1).save

        url = Crawler::Url.find(url: "http://www.google.com/path")
        url.to_s.should == "http://www.google.com/path"
        url.parent_url.should == "http://www.other.com"
        url.current_depth.should == 1
      end
    end
  end

  describe "delete" do
    it "delete existing url" do
      url = Crawler::Url.new(current_url: "http://www.google.com", parent_url: nil, current_depth: 0)
      url.save
      url.delete

      Crawler::Url.find(url: "http://www.google.com/path").should == nil
    end
  end
end