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
      rescue StandardError => e
        $LOG.error e.message
        $LOG.debug e.backtrace.join("\n")
        nil
      end
    end

    def head
      begin
        Mechanize.new.head(@url)
      rescue StandardError => e
        $LOG.error e.message
        $LOG.debug e.backtrace.join("\n")
        nil
      end
    end

    def valid_response?
      response_code = head.code
      !response_code.nil? &&
      response_code.match(/4\d\d/).nil? &&
      response_code.match(/5\d\d/).nil?
    end
  end
end