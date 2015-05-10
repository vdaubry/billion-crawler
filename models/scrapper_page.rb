class ScrapperPage
  attr_accessor :page
  
  def initialize(url:)
    @page = get_page(url: url)
  end
  
  def links
    return if @page.nil?
    @page.links.map do |link| 
      if @page.uri && link.uri
        (@page.uri.merge link.uri).to_s
      end
    end.compact
  end
  
  def images
    return if @page.nil?
    @page.images.map(&:url)
  end
  
  def contains?(url:)
    url_host = URI.parse(url).host_with_sublevel_domain
    page_host = @page.uri.host_with_sublevel_domain
    url_host == page_host
  end
  
  private
  
  def get_page(url:)
    agent = Mechanize.new
    agent.open_timeout=5
    
    if ENV['APP_ENV'] != 'production'
      agent.ca_file = "/usr/local/etc/openssl/certs/Equifax_Secure_Certificate_Authority.pem"
    end
    
    agent.get(url)
  end
end