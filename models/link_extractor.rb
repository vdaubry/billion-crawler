class LinkExtractor
  def initialize(page:)
    @page = page
  end
  
  def extract
    @page.links.each do |url|
      if @page.contains?(url: url)
        if ScrapperBloomFilter.new.include?(key: url)
          puts "Page already crawled : #{url}"
          next 
        end
        
        domain = ScrapperDomain.new(host: URI.parse(url).host_with_sublevel_domain)
        domain.add_url(url: url)
      end
    end
  end
end