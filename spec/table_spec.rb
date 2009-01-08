
describe Terminal::Table do
  
  before :each do
    @table = Terminal::Table.new
  end

  it "should calculate padding" do
    @table << [1, 2, 3, 4]
    @table.padding.should == 8
  end
  
  it "should calculate number of columns" do
    @table << [1, 2, 3, 4]
    @table.number_of_columns.should == 4
  end
    
  it "should calculate heading chars without padding" do
    @table << ['a', 1]
    @table.headings = ['Characters', 'Numbers']
    @table.headings_length.should == 17
  end
  
  it "should calculate heading chars with padding" do
    @table << ['a', 1]
    @table.headings = ['Characters', 'Numbers']
    @table.headings_length_with_padding.should == 21
  end

  it "should calculate largest row" do
    @table << ['foo', 'bar', 'a']
    @table << ['big foo', 'big bar']
    @table.largest_row.should == ['big foo', 'big bar']
  end
  
  it "should calculate heading chars without padding" do
    @table << ['foo', 'bar']
    @table << ['big foo', 'big bar']
    @table.length_of_largest_row.should == 14 
  end

  it "should calculate heading chars with padding" do
    @table << ['foo', 'bar']
    @table << ['big foo', 'big bar']
    @table.length_of_largest_row_with_padding.should == 18 
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
      +------+-----+
      | a    | 1   |
      | b    | 2   |
      | c    | 3   |
      +------+-----+
    EOF
  end
  
  it "should render properly without headings and row seperators" do
    @table << ['a', 1]
    @table << ['b', 2]
    @table << ['c', 3]
    @table.render.should == <<-EOF.deindent
      +------+-----+
      | a    | 1   |
      +------+-----+
      | b    | 2   |
      +------+-----+
      | c    | 3   |
      +------+-----+
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
    @table.headings = ['Characters', { :value => 'N', :align => :right }]
    @table << [{ :value => 'a', :align => :center }, 1]
    @table << ['b', 2]
    @table << ['c', 3]
    @table.render.should == <<-EOF.deindent
      +------------+-----+
      | Characters |   N |
      +------------+-----+
      |     a      | 1   |
      | b          | 2   |
      | c          | 3   |
      +------------+-----+
    EOF
  end
  
  it "should align columns" do
    @table.headings = ['Just some characters', 'Num']
    @table.rows = [[{ :value => 'a', :align => :center }, 1], ['b', 2], ['c', 3]]
    @table.align_column 1, :center
    @table.align_column 2, :right
    @table.render.should == <<-EOF.deindent
      +----------------------+-----+
      | Just some characters | Num |
      +----------------------+-----+
      |          a           |  1  |
      |          b           |   2 |
      |          c           |   3 |
      +----------------------+-----+
    EOF
  end
  
end