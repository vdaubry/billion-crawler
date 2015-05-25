require "spec_helper"

describe ScrapperPage do
  describe "links", :vcr => true do
    it "returns page links" do
      links = ScrapperPage.new(url: "http://www.google.fr").links
      links.count.should == 22
      links.first.should == "http://www.google.fr/imghp?hl=fr&tab=wi"
    end
    
    context "page doesn't exist" do
      it "raises exception" do
        expect { 
          ScrapperPage.new(url: "http://fake.google.fr").links 
        }.to raise_error(StandardError)
      end
    end
    
    context "url not valid" do
      it "raises exception" do
        expect { 
          ScrapperPage.new(url: "fake.google.fr").links
        }.to raise_error(StandardError)
      end
    end
    
    context "page contains empty links" do
      it "ignores empty links" do
        links = ScrapperPage.new(url: "https://en.wikipedia.org/wiki/Main_Page").links
        links.count.should == 299
      end
      
      it "doesn't return empty links" do
        links = ScrapperPage.new(url: "https://en.wikipedia.org/wiki/Main_Page").links
        links.include?(nil).should == false
      end
    end
  end
  
  describe "images", :vcr => true do
    it "returns page images" do
      images = ScrapperPage.new(url: "http://www.google.fr").images
      images.count.should == 1
      images.first.to_s.should == "http://www.google.fr/images/icons/product/chrome-48.png"
    end
    
    context "page doesn't exist" do
      it "raises exception" do
        expect { 
          ScrapperPage.new(url: "http://fake.google.fr").images 
        }.to raise_error(StandardError)
      end
    end
    
    context "url not valid" do
      it "raises exception" do
        expect { 
          ScrapperPage.new(url: "fake.google.fr").images
        }.to raise_error(StandardError)
      end
    end
  end
  
  describe "contains?", vcr: true do
    it { ScrapperPage.new(url: "http://www.google.fr").contains?(url: "http://www.google.fr/a.html").should == true }
    it { ScrapperPage.new(url: "http://www.google.fr").contains?(url: "https://play.google.fr/?hl=fr&tab=w8").should == true }
    it { ScrapperPage.new(url: "http://www.google.fr").contains?(url: "https://www.google.fr/a.html").should == true }
    it { ScrapperPage.new(url: "http://www.google.fr").contains?(url: "http://google.fr/a.html").should == true }
    it { ScrapperPage.new(url: "http://www.google.co.uk").contains?(url: "http://abc.google.co.uk/a.html").should == true }
  end
end