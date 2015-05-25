require "spec_helper"

describe LinkExtractor do
  
  let(:page) { ScrapperPage.new(url: "http://www.google.fr") }
  
  describe "links", :vcr => true do
    it "adds links to the domain url list" do
      ScrapperDomain.any_instance.expects(:add_url).times(16)
      LinkExtractor.new(page: page).extract
    end
    
    it "returns links as absolute url" do
      links = LinkExtractor.new(page: page).extract
      links.count.should == 22
      links.first.to_s.should == "http://www.google.fr/imghp?hl=fr&tab=wi"
    end
  end
end