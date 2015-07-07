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

  describe "url_known?" do
    it "returns false for first time seen image" do
      image.url_known?.should == false
    end

    it "returns true for already seen image" do
      image.known!
      image.url_known?.should == true
    end    
  end

  describe "content_known?" do
    it "returns false for first time seen image" do
      image.content_known?.should == false
    end

    it "returns false for already seen small image" do
      image.known!
      image.content_known?.should == false
    end

    it "returns true for already seen large image" do      
      image = PageProcessor::Image.new(url: "https://www.google.fr/logos/2015/tsuburaya/cta-jpg-sprite.jpg", thumb_size: 300)
      image.known!
      image.content_known?.should == true
    end
  end

  describe "dimension" do
    context "invalid image extension" do
      it "reads files with mismatch between extension and image type" do
        image = PageProcessor::Image.new(url: "http://i.ytimg.com/i/-9-kyTW8ZkZNDHQJ6FgpwQ/1.jpg", thumb_size: 300)
        image.dimension.should == 88
      end
    end

    context "image doesn't exist" do
      it "returns nil" do
        image = PageProcessor::Image.new(url: "http://freedomdefined.org/Resources/assets/poweredby_mediawiki_88x31.png", thumb_size: 300)
        image.dimension.should == nil
      end
    end
  end

  describe "size_too_small?" do
    it "returns true if dimension is nil" do
      image.stubs(:dimension).returns(nil)
      image.size_too_small?.should == true
    end
  end
end