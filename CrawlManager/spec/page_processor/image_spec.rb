require "spec_helper"

describe PageProcessor::Image, vcr: true do

  let(:image) { PageProcessor::Image.new(url: "https://www.google.fr/images/icons/product/chrome-48.png", thumb_size: 300) }

  before(:each) do
    Time.stubs(:now).returns(Date.parse("20/10/2010").to_time)
  end

  describe "thumbnail_key" do
    it "returns image name with thumb size" do
      image.thumbnail_key.should == "0065257821_chrome-48_300x300.png"
    end
  end

  describe "key" do
    it "returns a unique key for the image" do
      image.key.should == "0065257821_chrome-48.png"
    end
  end

  describe "thumbnail_data" do
    it "returns thumbnail data" do
      image.thumbnail_data.size.should == 5603
    end
  end

  describe "data" do
    it "downloads image data" do
      image.data.size.should == 1834
    end
  end

  describe "known?" do
    it "returns false for first time seen image" do
      image.known?.should == false
    end

    it "returns true for already seen image" do
      image.known!
      image.known?.should == true
    end    
  end
end