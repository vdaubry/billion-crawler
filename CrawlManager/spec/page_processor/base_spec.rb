require "spec_helper"

describe PageProcessor::Base, vcr: true do

  let(:processor) { PageProcessor::Base.new }
  
  describe "process" do
    context "page with one large image" do
      let(:html) { File.read("spec/fixtures/html_sample/techslides.com.html") }

      it "stores downloaded images" do
        Facades::Storage.any_instance.expects(:store).times(2)
        processor.process(html: html, base_url: "http://techslides.com", url: "http://techslides.com/page")
      end

      it "sets all images hash as already seen" do
        PageProcessor::Image.any_instance.expects(:known!).times(10)
        processor.process(html: html, base_url: "http://techslides.com", url: "http://techslides.com/page")
      end

      it "sends a message to the queue" do
        Facades::Queue.any_instance.expects(:send).times(1)
        processor.process(html: html, base_url: "http://techslides.com", url: "http://techslides.com/page")
      end

      it "sets all images urls as already seen" do
        PageProcessor::WebPage.any_instance.expects(:already_seen!).times(1)
        processor.process(html: html, base_url: "http://techslides.com", url: "http://techslides.com/page")
      end

      it "calls done on url frontier" do
        Crawler::UrlFrontier.any_instance.expects(:done).with(url: "http://techslides.com/page")
        processor.process(html: html, base_url: "http://techslides.com", url: "http://techslides.com/page")
      end
    end
  end
end