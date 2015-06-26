module Crawler::Interfaces
  class Downloader
    def download(url:)
      #@rabbit_client.send(msg: {url: url}, queue_name: "download_page")
      
    end
  end
end