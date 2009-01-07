
describe TerminalTable do
  
  before :each do
    @table = TerminalTable.new
  end
  
  it "should render properly" do
    @table << ['Character', 'Number']
    @table << ['a', 1]
    @table << ['b', 2]
    @table << ['c', 3]
    @table.render.should == <<-EOF.deindent
      +--------------------+
      | Character | Number |
      +-----------+--------+
      | a         | 1      |
      | b         | 2      |
      | c         | 3      |
      +-----------+--------+
    EOF
  end
  
  it "should allows a hash of options for creation" do

  end
  
end