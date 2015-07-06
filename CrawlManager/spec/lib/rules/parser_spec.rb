require "spec_helper"

describe Rules::Parser do
  describe "read" do
    it "updates conf" do
      Rules::Parser.new(yaml: "spec/fixtures/config/blacklist_only.yml").read
      Rules::Parser.new(yaml: "spec/fixtures/config/whitelist_only.yml").read
      $redis.hgetall("bc:rules:techcrunch.com").should ==  {"blacklist"=>"", "whitelist"=>"[\"gadgets\",\"inside-jobs\"]"}
    end


    context "blacklist only" do
      it "sets nil whitelist" do
        Rules::Parser.new(yaml: "spec/fixtures/config/blacklist_only.yml").read
        $redis.hgetall("bc:rules:techcrunch.com").should ==  {"blacklist"=>"[\"startup\",\"mobile\"]", "whitelist"=> ""}
      end
    end

    context "whitelist only" do
      it "sets nil blacklist" do
        Rules::Parser.new(yaml: "spec/fixtures/config/whitelist_only.yml").read
        $redis.hgetall("bc:rules:techcrunch.com").should ==  {"blacklist"=>"", "whitelist"=>"[\"gadgets\",\"inside-jobs\"]"}
      end
    end

    context "blacklist and whitelist" do
      it "sets blacklist and whitelist" do
        Rules::Parser.new(yaml: "spec/fixtures/config/blacklist_and_whitelist.yml").read
        $redis.hgetall("bc:rules:techcrunch.com").should ==  {"blacklist"=>"[\"startup\",\"mobile\"]", "whitelist"=>"[\"gadgets\",\"mobile\"]"}
      end
    end    

    context "no blacklist and no whitelist" do
      it "sets nil blacklist and nil whitelist" do
        Rules::Parser.new(yaml: "spec/fixtures/config/no_whitelist_and_no_blacklist.yml").read
        $redis.hgetall("bc:rules:otherhost.com").should ==  {"blacklist"=>"", "whitelist"=>""}
      end
    end
  end
end