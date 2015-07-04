module Downloader
  class WebPage
    def initialize(url:)
      @url = url
    end
    
    def data
      Facades::HTTPDownloadFacade.new(url: @url).download
    end
    
    def key
      uri = URI.parse(@url)
      path = uri.path.empty? ? "/index.html" : uri.path
      key = "#{uri.host}#{path}"
    end

    def base_url
      uri = URI.parse(@url)
      "#{uri.scheme}://#{uri.host}"
    end
  end
end