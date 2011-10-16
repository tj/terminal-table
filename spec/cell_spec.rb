
require File.dirname(__FILE__) + '/spec_helper'

describe Terminal::Table do
  Cell = Terminal::Table::Cell
  
  it "should default alignment to the left" do
    cell = Cell.new :value => 'foo', :table => Terminal::Table.new, :index => 0
    cell.value.should == 'foo'
    cell.alignment.should == :left
  end

  it "should allow overriding of alignment" do
    cell = Cell.new :value => 'foo', :alignment => :center, :table => Terminal::Table.new, :index => 0
    cell.value.should == 'foo'
    cell.alignment.should == :center
  end
  
  it "should allow multiline content" do
    cell = Cell.new :value => "foo\nbarrissimo", :table => Terminal::Table.new, :index => 0
    cell.value.should == "foo\nbarrissimo"
    cell.lines.should == ['foo', 'barrissimo']
    cell.value_for_column_width_recalc.should == 'barrissimo'
    cell.render(1).should == " barrissimo "
  end

end
