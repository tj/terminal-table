
require File.dirname(__FILE__) + '/spec_helper'

describe Terminal::Table do
  Row = Terminal::Table::Row
  
  it "should default alignment to the left" do
    row = Row.new Terminal::Table.new, ["a", "b", "c"]
    cell = row.cells.first
    cell.value.should == 'a'
    cell.alignment.should == :left
  end

  it "should allow overriding of alignment" do
    row = Row.new Terminal::Table.new, [{:value => 'a', :alignment => :center}, "b", "c"]
    cell = row.cells.first
    cell.value.should == 'a'
    cell.alignment.should == :center
  end

  it "should calculate height for multiline cells" do
    row = Row.new Terminal::Table.new, [{:value => 'a', :alignment => :center}, "b", "c\nb"]
    row.height.should == 2
  end
end
