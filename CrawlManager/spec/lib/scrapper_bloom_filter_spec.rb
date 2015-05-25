require "spec_helper"

describe "ScrapperBoomFilter" do

  let(:bf) { ScrapperBloomFilter.new }

  describe "insert / include" do
    it "adds a new element to filter" do
      bf.insert(key: "foo")
      bf.include?(key: "foo").should == true
      bf.include?(key: "foo1").should == false
    end
    
    it "doesn't inserts nil" do
      bf.insert(key: nil) rescue InvalidKeyError
      bf.include?(key: nil).should == false
    end
    
    it "doesn't inserts empty" do
      bf.insert(key: "") rescue InvalidKeyError
      bf.include?(key: "").should == false
    end
  end
end