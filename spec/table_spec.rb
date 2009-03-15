
describe Terminal::Table do
  
  before :each do
    @table = Terminal::Table.new
  end
   
  it "should select columns" do
    @table << ['foo', 'bar']
    @table << ['big foo', 'big foo bar']
    @table.column(1).should == ['bar', 'big foo bar']
  end
  
  it "should count columns" do
    @table << [1, 2, 3]
    @table.number_of_columns.should == 3
  end
  
  it "should iterate columns" do
    @table << [1, 2, 3]
    @table << [4, 5, 6]
    @table.columns.should == [[1, 4], [2, 5], [3, 6]]
  end
  
  it "should select columns" do
    @table.headings = ['one', 'two']
    @table << ['foo', 'bar']
    @table << ['big foo', 'big foo bar']
    @table.column(1).should == ['bar', 'big foo bar']
  end
  
  it "should select columns when using hashes" do
    @table.headings = ['one', 'two']
    @table.rows = [[{ :value => 'a', :align => :left }, 1], ['b', 2], ['c', 3]]
    @table.column(0).should == [{ :value => 'a', :align => :left }, 'b', 'c']
  end
  
  it "should select largest cell in a column" do
    @table << ['foo', 'bar']
    @table << ['big foo', 'big foo bar']
    @table.largest_cell_in_column(1).should == 'big foo bar'
  end
  
  it "should find column length" do
    @table << ['foo', 'bar', 'a']
    @table << ['big foo', 'big foo bar']
    @table.length_of_column(1).should == 11
  end
  
  it "should find column length with headings" do
    @table.headings = ['one', 'super long heading']
    @table << ['foo', 'bar', 'a']
    @table << ['big foo', 'big foo bar']
    @table.length_of_column(1).should == 18
  end
  
  it "should render seperators" do
    @table.headings = ['Char', 'Num']
    @table << ['a', 1]
    @table.seperator.should == '+------+-----+'
  end
  
  it "should bitch and complain when you have no rows" do
    lambda { @table.render }.should raise_error(Terminal::Table::Error)
  end
      
  it "should render properly" do
    @table.headings = ['Char', 'Num']
    @table << ['a', 1]
    @table << ['b', 2]
    @table << ['c', 3]
    @table.render.should == <<-EOF.deindent
      +------+-----+
      | Char | Num |
      +------+-----+
      | a    | 1   |
      | b    | 2   |
      | c    | 3   |
      +------+-----+
    EOF
  end
  
  it "should render properly without headings" do
    @table << ['a', 1]
    @table << ['b', 2]
    @table << ['c', 3]
    @table.render.should == <<-EOF.deindent
      +---+---+
      | a | 1 |
      | b | 2 |
      | c | 3 |
      +---+---+
    EOF
  end
  
  it "should render properly using block syntax" do
    table = Terminal::Table.new do |t|
      t << ['a', 1]
      t << ['b', 2]
      t << ['c', 3]
    end
    table.render.should == <<-EOF.deindent
      +---+---+
      | a | 1 |
      | b | 2 |
      | c | 3 |
      +---+---+
    EOF
  end
  
  it "should render properly using instance_eval block syntax" do
    table = Terminal::Table.new do
      add_row ['a', 1]
      add_row ['b', 2]
      add_row ['c', 3]
    end
    table.render.should == <<-EOF.deindent
      +---+---+
      | a | 1 |
      | b | 2 |
      | c | 3 |
      +---+---+
    EOF
  end
  
  it "should allows a hash of options for creation" do
    headings = ['Char', 'Num']
    rows = [['a', 1], ['b', 2], ['c', 3]]
    Terminal::Table.new(:rows => rows, :headings => headings).render.should == <<-EOF.deindent
      +------+-----+
      | Char | Num |
      +------+-----+
      | a    | 1   |
      | b    | 2   |
      | c    | 3   |
      +------+-----+
    EOF
  end
  
  it "should flex for large cells" do
    @table.headings = ['Just some characters', 'Num']
    @table.rows = [['a', 1], ['b', 2], ['c', 3]]
    @table.render.should == <<-EOF.deindent
      +----------------------+-----+
      | Just some characters | Num |
      +----------------------+-----+
      | a                    | 1   |
      | b                    | 2   |
      | c                    | 3   |
      +----------------------+-----+
    EOF
  end
  
  it "should allow alignment of headings and cells" do
    @table.headings = ['Characters', ['Nums', :right ]]
    @table << [['a', :center ], 1]
    @table << ['b', 222222222222222]
    @table << ['c', 3]
    @table.render.should == <<-EOF.deindent
      +------------+-----------------+
      | Characters |            Nums |
      +------------+-----------------+
      |     a      | 1               |
      | b          | 222222222222222 |
      | c          | 3               |
      +------------+-----------------+
    EOF
    
  end
  
  it "should align columns, but allow specifics to remain" do
    @table.headings = ['Just some characters', 'Num']
    @table.rows = [[['a', :left], 1], ['b', 2], ['c', 3]]
    @table.align_column 0, :center
    @table.align_column 1, :right
    @table.render.should == <<-EOF.deindent
      +----------------------+-----+
      | Just some characters | Num |
      +----------------------+-----+
      | a                    |   1 |
      |          b           |   2 |
      |          c           |   3 |
      +----------------------+-----+
    EOF
  end
  
end