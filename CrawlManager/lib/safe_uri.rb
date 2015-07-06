class SafeUri
  def self.join(base_url:, path:)
    begin
      URI.join(base_url, URI.encode(path)).to_s if path
    rescue StandardError => e
      $LOG.error e
      nil
    end
  end
end