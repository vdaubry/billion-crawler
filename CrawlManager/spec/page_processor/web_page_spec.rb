require "spec_helper"

describe PageProcessor::WebPage do

  let(:web_page) { PageProcessor::WebPage.new(html: File.read("spec/fixtures/html_sample/google.fr.html"), base_url: "http://www.google.fr") }

  describe "all_images" do
    it "returns images in page" do
      web_page.all_images.should == ["http://www.google.fr/images/nav_logo195.png", "data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="]
    end
  end

  describe "filter_by_extensions" do
    it "returns images with allowed extensions" do
      images = ["http://www.google.fr/test.gif", "http://www.google.fr/test.jpeg", "http://www.google.fr/test.jpg", "http://www.google.fr/images/nav_logo195.png", "data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="]
      web_page.filter_by_extensions(images: images).should == ["http://www.google.fr/test.jpeg", "http://www.google.fr/test.jpg", "http://www.google.fr/images/nav_logo195.png"]
    end
  end

  describe "exclude_already_seen" do
    it "excludes images with url present in bloom filter" do
      BloomFilterFacade.new.insert(key: "http://www.google.fr/test.png")
      images = ["http://www.google.fr/test.png", "http://www.google.fr/test.jpg"]
      web_page.exclude_already_seen(images: images).should == ["http://www.google.fr/test.jpg"]
    end
  end
end