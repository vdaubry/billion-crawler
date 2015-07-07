module Facades
  class HTTPDownloadFacade
    def initialize(url:)
      @url = url
    end

    def download
      begin
        body = nil
        time = Benchmark.realtime do
          body = Mechanize.new.get(@url).body
        end
        $LOG.info "Downloaded #{@url} in #{time}"
        body
      rescue Mechanize::ResponseCodeError, Net::HTTP::Persistent::Error => e
        $LOG.error e.message
        $LOG.debug e.backtrace.join("\n")
        nil
      end
    end
  end
end