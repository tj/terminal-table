
describe Terminal::Table do
  
  Cell = Terminal::Table::Cell
  
  it "should default alignment to the left" do
    cell = Cell.new 0, 'foo'
    cell.value.should == 'foo'
    cell.alignment.should == :left
  end

  it "should override alignment" do
    cell = Cell.new 0, 'foo', :center
    cell.value.should == 'foo'
    cell.alignment.should == :center
  end
  
end