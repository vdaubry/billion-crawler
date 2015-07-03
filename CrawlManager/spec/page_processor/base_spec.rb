require "spec_helper"

describe PageProcessor::Base, vcr: true do

  let(:processor) { PageProcessor::Base.new }
  let(:html) { File.read("spec/fixtures/html_sample/google.fr.html") }

  describe "process" do
    it "stores downloaded images" do
      Facades::Storage.any_instance.expects(:store).times(2)
      processor.process(html: html, base_url: "http://www.google.fr")
    end

    it "sets image as already seen" do
      PageProcessor::Image.any_instance.expects(:known!).times(1)
      processor.process(html: html, base_url: "http://www.google.fr")
    end

    it "sends a message to the queue" do
      Facades::Queue.any_instance.expects(:send).times(1)
      processor.process(html: html, base_url: "http://www.google.fr")
    end    
  end
end