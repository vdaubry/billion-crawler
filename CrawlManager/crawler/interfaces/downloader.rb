module Crawler::Interfaces
  class Downloader
    def download(url:)
      Downloader::Base.new.download({"url": url}.to_json)
    end
  end
end