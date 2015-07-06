module Facades
  class HTTPDownloadFacade
    def initialize(url:)
      @url = url
    end

    def download
      begin
        Mechanize.new.get(@url).body
      rescue Mechanize::ResponseCodeError => e
        $LOG.error e
        nil
        rescue Net::HTTP::Persistent::Error => e
        $LOG.error e
        nil
      end
    end
  end
end