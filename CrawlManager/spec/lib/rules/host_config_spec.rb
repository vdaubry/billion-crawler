require "spec_helper"

describe Rules::HostConfig do
  let(:host) { Rules::HostConfig.new(host: "techcrunch.com") }

  context "helper methods" do
    before(:each) do
      Rules::Parser.new(yaml: "spec/fixtures/config/blacklist_and_whitelist.yml").read
    end

    describe "in_whitelist?" do
      it { host.in_whitelist?(url: "http://techcrunch.com/gadgets/foo.html").should == true }
      it { host.in_whitelist?(url: "http://techcrunch.com/bar/foo.html").should == false }
    end

    describe "in_blacklist?" do
      it { host.in_blacklist?(url: "http://techcrunch.com/startup/foo.html").should == true }
      it { host.in_blacklist?(url: "http://techcrunch.com/bar/foo.html").should == false }
    end
  end

  describe "url_allowed?" do
    context "blacklist only" do
      it "allows url not in blacklist" do
        Rules::Parser.new(yaml: "spec/fixtures/config/blacklist_only.yml").read
        host.url_allowed?(url: "http://techcrunch.com/startup/foo.html").should == false
        host.url_allowed?(url: "http://techcrunch.com/other/foo.html").should == true
      end
    end

    context "whitelist only" do
      it "allows only url in whitelist" do
        Rules::Parser.new(yaml: "spec/fixtures/config/whitelist_only.yml").read
        host.url_allowed?(url: "http://techcrunch.com/gadgets/foo.html").should == true
        host.url_allowed?(url: "http://techcrunch.com/other/foo.html").should == false
      end
    end

    context "blacklist and whitelist" do
      it "ignores blacklist" do
        Rules::Parser.new(yaml: "spec/fixtures/config/blacklist_and_whitelist.yml").read
        host.url_allowed?(url: "http://techcrunch.com/mobile/foo.html").should == true
        host.url_allowed?(url: "http://techcrunch.com/other/foo.html").should == false
      end
    end    

    context "no blacklist and no whitelist" do
      it "allows all urls" do
        Rules::Parser.new(yaml: "spec/fixtures/config/no_whitelist_and_no_blacklist.yml").read
        host.url_allowed?(url: "http://techcrunch.com/gadgets/foo.html").should == true
        host.url_allowed?(url: "http://techcrunch.com/other/foo.html").should == true
      end
    end
  end
end