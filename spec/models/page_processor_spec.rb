require "spec_helper"

describe PageProcessor do
  
  let(:page) { ScrapperPage.new(url: "http://www.google.fr") }
  
  describe "process", vcr: true do
    it "returns all images" do
      images = PageProcessor.new(page: page).process
      images.count.should == 1
      images.first.to_s.should == "http://www.google.fr/images/icons/product/chrome-48.png"
    end
  end
end