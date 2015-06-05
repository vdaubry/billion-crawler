class WebPage
  def initialize(url:)
    @url = url
  end
  
  def data
    Mechanize.new.get(@url).body
  end
  
  def key
    uri = URI.parse(@url)
    path = uri.path.empty? ? "/index.html" : uri.path
    key = "#{uri.host}#{path}"
  end
end