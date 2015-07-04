require "spec_helper"

describe Downloader::LinkExtractor do
  describe "extract" do
    it "returns links from page" do
      html = File.read("spec/fixtures/html_sample/google.fr.html")
      extractor = Downloader::LinkExtractor.new(html: html, base_url: "http://www.google.fr")
      links = extractor.extract
      links.count.should == 15
      links.first.should == "https://www.google.fr/imghp?hl=en&tab=wi&ei=N1mWVeqxHIvbU9r8gdAC&ved=0CBAQqi4oAQ"
    end

    it "returns links from page with special char in links" do
      html = File.read("spec/fixtures/html_sample/creativecommons.org.html")
      extractor = Downloader::LinkExtractor.new(html: html, base_url: "http://creativecommons.org")
      extractor.extract.count.should == 14
    end
  end

  describe "url_valid?" do
    let(:extractor) { Downloader::LinkExtractor.new(html: "", base_url: "http://google.fr") }
    
    it "allows valid http / https link" do
      extractor.url_valid?(url: "http://google.fr/foo").should == true
      extractor.url_valid?(url: "https://google.fr/foo").should == true
    end

    it "forbids not http link" do
      extractor.url_valid?(url: "ftp://google.fr/foo").should == false
    end

    it "forbids invalid http link" do
      extractor.url_valid?(url: "http://google").should == false
    end

    it "forbids links to outside host" do
      extractor.url_valid?(url: "http://foo.bar").should == false
    end

    it "allow url on same host" do
      extractor.url_valid?(url: "http://www.google.fr/setprefs?suggon=2&prev=https://www.google.fr/webhp?hl%253Den&sig=0_UP1o-z2PkxIhw6q5WnhfGhV_mF4%253D").should == true
    end
  end
end