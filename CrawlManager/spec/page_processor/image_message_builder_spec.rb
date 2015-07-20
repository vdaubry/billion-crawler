require "spec_helper"

describe PageProcessor::ImageMessageBuilder do
  describe "to_json" do
    it "serialize a message with image" do
      image = PageProcessor::Image.new(src: "http://img.com/1.jpg")
      Time.stubs(:now).returns(DateTime.parse("2010/01/01"))
      json = PageProcessor::ImageMessageBuilder.new("http://foo.bar", "foo", "http://foo.bar/post", image).to_json
      JSON.parse(json).should == {"website"=>{"url"=>"http://foo.bar"}, "post"=>{"name"=>"foo", "url"=>"http://foo.bar/post"}, "image"=>{"src"=>"http://img.com/1.jpg", "scrapped_at"=>"2010-01-01T00:00:00+00:00"}}
    end

    it "serialize a message with image" do
      image_link = PageProcessor::ImageLink.new(src: "http://img.com/1.jpg", href: "http://google.com")
      Time.stubs(:now).returns(DateTime.parse("2010/01/01"))
      json = PageProcessor::ImageMessageBuilder.new("http://foo.bar", "foo", "http://foo.bar/post", image_link).to_json
      JSON.parse(json).should == {"website"=>{"url"=>"http://foo.bar"}, "post"=>{"name"=>"foo", "url"=>"http://foo.bar/post"}, "image"=>{"src"=>"http://img.com/1.jpg", "href" => "http://google.com", "scrapped_at"=>"2010-01-01T00:00:00+00:00"}}
    end
  end
end