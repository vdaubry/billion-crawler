require "spec_helper"

describe Downloader::LinkExtractor do
  describe "extract" do
    it "returns links from page" do
      html = File.read("spec/fixtures/html_sample/google.fr.html")
      extractor = Downloader::LinkExtractor.new(html: html, base_url: "http://www.google.fr")
      links = extractor.extract
      links.count.should == 45
      links.first.should == "http://www.google.fr/setprefs?suggon=2&prev=https://www.google.fr/webhp?hl%3Den&sig=0_UP1o-z2PkxIhw6q5WnhfGhV_mF4%3D"
    end
  end
end