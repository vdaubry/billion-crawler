require "spec_helper"

describe PageProcessor do
  
  let(:page) { ScrapperPage.new(url: "http://www.google.fr") }
  
  describe "process", vcr: true do
    it "adds url to counter" do
      PageProcessor.new(page: page).process
      domain = ScrapperDomain.new(host: URI.parse(page.url).host_with_sublevel_domain)
      domain.count_urls.should == 1
    end
  end
end