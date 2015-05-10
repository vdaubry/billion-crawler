class PageProcessor
  def initialize(page:)
    @page = page
  end
  
  def process
    @page.images
  end
end