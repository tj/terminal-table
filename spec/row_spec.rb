require 'spec_helper'

describe Terminal::Table do
  Row = Terminal::Table::Row

  it "should default alignment to the left" do
    row = Row.new Terminal::Table.new, ["a", "b", "c"]
    cell = row.cells.first
    cell.value.should eq 'a'
    cell.alignment.should eq :left
  end

  it "should allow overriding of alignment" do
    row = Row.new Terminal::Table.new, [{:value => 'a', :alignment => :center}, "b", "c"]
    cell = row.cells.first
    cell.value.should eq 'a'
    cell.alignment.should eq :center
  end

  it "should calculate height for multiline cells" do
    row = Row.new Terminal::Table.new, [{:value => 'a', :alignment => :center}, "b", "c\nb"]
    row.height.should eq 2
  end
end
