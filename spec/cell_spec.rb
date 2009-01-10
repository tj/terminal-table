
describe Terminal::Table do
  
  Cell = Terminal::Table::Cell
  
  it "should initialize with a string" do
    cell = Cell.new 0, 'Foo'
    cell.value.should == 'Foo'
    cell.alignment.should == :left
  end
  
  it "should initialize with a hash" do
    cell = Cell.new 0, :value => 'Bar', :align => :right
    cell.value.should == 'Bar'
    cell.alignment.should == :right    
  end
  
end