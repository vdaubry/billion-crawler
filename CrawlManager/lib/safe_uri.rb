class SafeUri
  def self.join(base_url:, path:)
    begin
      URI.join(base_url, URI.encode(path)).to_s if path
    rescue StandardError => e
      $LOG.error e.message
      $LOG.debug e.backtrace.join("\n")
      nil
    end
  end
end