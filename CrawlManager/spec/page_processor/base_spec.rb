require "spec_helper"

describe PageProcessor::Base, vcr: true do

  let(:processor) { PageProcessor::Base.new }
  
  describe "process" do
    context "page with one large image" do
      let(:html) { File.read("spec/fixtures/html_sample/techslides.com.html") }

      it "sets images links as already seen" do
        PageProcessor::ImageLink.any_instance.expects(:known!).times(9)
        processor.process(html: html, base_url: "http://techslides.com", url: "http://techslides.com/page")
      end

      it "sends only valid images to the queue" do
        Facades::Queue.any_instance.expects(:send).times(0)
        processor.process(html: html, base_url: "http://techslides.com", url: "http://techslides.com/page")
      end

      it "sets only valid images urls as already seen" do
        PageProcessor::Image.any_instance.expects(:already_seen!).times(0)
        processor.process(html: html, base_url: "http://techslides.com", url: "http://techslides.com/page")
      end

      it "calls done on url frontier" do
        Crawler::UrlFrontier.any_instance.expects(:done).with(url: "http://techslides.com/page")
        processor.process(html: html, base_url: "http://techslides.com", url: "http://techslides.com/page")
      end
    end
  end
end