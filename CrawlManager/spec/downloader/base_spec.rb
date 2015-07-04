require "spec_helper"

describe Downloader::Base, vcr: true do

  let(:downloader) { Downloader::Base.new }

  describe "download" do
    it "calls process page" do
      PageProcessor::Base.any_instance.expects(:process)
      downloader.download(url: "http://www.google.fr")
    end

    it "crawls news links from page" do
      Crawler::FoundUrl.any_instance.expects(:crawl).times(7)
      downloader.download(url: "http://www.google.fr")
    end
  end
end