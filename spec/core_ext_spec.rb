
require File.dirname(__FILE__) + '/spec_helper'

describe String do
  describe "#align" do
    it "should center" do
      'foo'.align(:center, 10).should == '   foo    '
    end
    
    it "should align left" do
      'foo'.align(:left, 10).should == 'foo       '
    end
  
    it "should align right" do
      'foo'.align(:right, 10).should == '       foo'
    end
  end
end
