require "spec_helper"

describe Downloader::WebPage do

  let(:web_page) { Downloader::WebPage.new(url: "http://www.google.fr") }
  let(:web_page_with_path) { Downloader::WebPage.new(url: "https://www.google.fr/search?q=rgfb") }

  describe "data", vcr: true do
    it "downloads webpage data" do
      web_page.data.size.should == 18991
    end
  end

  describe "key" do
    context "root url" do
      it "returns index.html" do
        web_page.key.should == "www.google.fr/index.html"
      end
    end

    context "has path" do
      it "returns web opage uri" do
        web_page_with_path.key.should == "www.google.fr/search"
      end
    end
  end

  describe "base_url" do
    it "returns root url" do
      web_page_with_path.base_url.should == "https://www.google.fr"
    end
  end
end