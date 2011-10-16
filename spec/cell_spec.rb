
require File.dirname(__FILE__) + '/spec_helper'

describe Terminal::Table do
  Cell = Terminal::Table::Cell
  
  it "should default alignment to the left" do
    cell = Cell.new 'foo'
    cell.value.should == 'foo'
    cell.alignment.should == :left
  end

  it "should allow overriding of alignment" do
    cell = Cell.new :value => 'foo', :alignment => :center
    cell.value.should == 'foo'
    cell.alignment.should == :center
  end
end
