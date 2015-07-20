require "spec_helper"

describe PageProcessor::Image, vcr: true do

  let(:image) { PageProcessor::Image.new(src: "https://www.google.fr/images/icons/product/chrome-48.png") }


  describe "known?" do
    it "returns false for first time seen image" do
      image.known?.should == false
    end

    it "returns true for already seen image" do
      image.known!
      image.known?.should == true
    end    
  end

  describe "dimension" do
    context "invalid image extension" do
      it "reads files with mismatch between extension and image type" do
        image = PageProcessor::Image.new(src: "http://i.ytimg.com/i/-9-kyTW8ZkZNDHQJ6FgpwQ/1.jpg")
        image.dimension.should == 88
      end
    end

    context "image doesn't exist" do
      it "returns nil" do
        image = PageProcessor::Image.new(src: "http://freedomdefined.org/Resources/assets/poweredby_mediawiki_88x31.png")
        image.dimension.should == nil
      end
    end
  end
end