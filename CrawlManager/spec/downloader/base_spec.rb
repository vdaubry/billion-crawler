require "spec_helper"

describe Downloader::Base, vcr: true do

  let(:downloader) { Downloader::Base.new }

  describe "download" do
    it "calls process page" do
      PageProcessor::Base.any_instance.expects(:process)
      downloader.download(url: "http://www.google.fr", current_depth: 0)
    end

    it "crawls news links from page" do
      Crawler::UrlFrontier.any_instance.expects(:add).times(22)
      downloader.download(url: "http://www.google.fr", current_depth: 0)
    end
  end
end