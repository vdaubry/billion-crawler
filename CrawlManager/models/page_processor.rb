class PageProcessor
  def initialize(page:)
    @page = page
  end
  
  def process
    url = @page.url
    domain = ScrapperDomain.new(host: URI.parse(url).host_with_sublevel_domain)
    domain.add_url_to_counter(url: url)
  end
end