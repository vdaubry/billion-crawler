require "spec_helper"

describe PageProcessor::WebPage do

  let(:web_page) { PageProcessor::WebPage.new(html: File.read("spec/fixtures/html_sample/google.fr.html"), base_url: "http://www.google.fr", url: "http://www.google.fr/page") }


  describe "images", vcr: true do
    it "returns valid images with allowed extensions" do
      web_page = PageProcessor::WebPage.new(html: File.read("spec/fixtures/html_sample/lemonde.fr.html"), base_url: "http://www.lemonde.fr/", url: "http://www.lemonde.fr/")
      web_page.images.map(&:src).should == ["http://s2.lemde.fr/image/2015/07/16/644x322/4686205_3_3305_file-d-attente-devant-le-distributeur-d-alpha_3b30b0438b6fba1bbd459fe383e30994.jpg"]
    end
  end

  describe "title" do
    it { web_page.title.should == "Google" }
  end
end