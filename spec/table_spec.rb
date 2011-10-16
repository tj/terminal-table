
require File.dirname(__FILE__) + '/spec_helper'

module Terminal
  describe Table do
    before :each do
      @table = Table.new
    end
    
    it "should select columns" do
      @table << ['foo', 'bar']
      @table << ['big foo', 'big foo bar']
      @table.column(1).should == ['bar', 'big foo bar']
    end

    it "should select the column with headings at an index" do
      @table << [1,2,3]
      @table << [4,5,6]
      @table.column_with_headings(2).should == [3,6]
    end

    it "should select the columns with colspans > 1 in the index" do
      @table << [1,{:value => 2, :colspan => 2}]
      @table << [{:value => 3, :colspan => 2}, 4]
    end

    it "should account for the colspan when selecting columns" do
      @table << [1,2,3]
      @table << [{:value => "4,5", :colspan => 2}, 6]
      @table.column_with_headings(0).should == [1,"4,5"]
      @table.column_with_headings(1).should == [2,"4,5"]
      @table.column_with_headings(2).should == [3,6]
    end

    it "should render tables with colspan properly" do
      @table << [1,2,3]
      @table << [4,5,6]
      @table << [{:value => "7", :colspan => 2}, 88]
      @table.render.should == <<-EOF.deindent
        +---+---+----+
        | 1 | 2 | 3  |
        | 4 | 5 | 6  |
        | 7     | 88 |
        +---+---+----+
      EOF
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
      @table.column(0).should == ['a', 'b', 'c']
    end

    it "should find column length" do
      @table << ['foo', 'bar', 'a']
      @table << ['big foo', 'big foo bar']
      @table.column_width(1).should == 11
    end

    it "should find column length with headings" do
      @table.headings = ['one', 'super long heading']
      @table << ['foo', 'bar', 'a']
      @table << ['big foo', 'big foo bar']
      @table.column_width(1).should == 18
    end

    it "should render separators" do
      @table.headings = ['Char', 'Num']
      @table << ['a', 1]
      @table.separator.should == '+------+-----+'
    end

    it "should add separator" do
      @table << ['a', 1]
      @table.add_separator
      @table << ['b', 2]
      @table.rows.size.should == 2
      @table.all_rows.size.should == 3
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

    it "should render separators" do
      @table.headings = ['Char', 'Num']
      @table << ['a', 1]
      @table << ['b', 2]
      @table.add_separator
      @table << ['c', 3]
      @table.render.should == <<-EOF.deindent
        +------+-----+
        | Char | Num |
        +------+-----+
        | a    | 1   |
        | b    | 2   |
        +------+-----+
        | c    | 3   |
        +------+-----+
      EOF
    end

    it "should align columns with separators" do
      @table.headings = ['Char', 'Num']
      @table << ['a', 1]
      @table << ['b', 2]
      @table.add_separator
      @table << ['c', 3]
      @table.align_column 1, :right
      @table.render.should == <<-EOF.deindent
        +------+-----+
        | Char | Num |
        +------+-----+
        | a    |   1 |
        | b    |   2 |
        +------+-----+
        | c    |   3 |
        +------+-----+
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
      @table.headings = ['Characters', {:value => 'Nums', :alignment => :right} ]
      @table << [{:value => 'a', :alignment => :center}, 1]
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
      @table.rows = [[{:value => 'a', :alignment => :left}, 1], ['b', 2], ['c', 3]]
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

    describe "#==" do
      it "should be equal to itself" do
        t = Table.new
        t.should == t
      end

      it "should be equal with two empty tables" do
        table_one = Table.new
        table_two = Table.new

        table_one.should == table_two
        table_two.should == table_one
      end

      it "should not be equal with different headings" do
        table_one = Table.new
        table_two = Table.new

        table_one.headings << "a"

        table_one.should_not == table_two
        table_two.should_not == table_one
      end

      it "should not be equal with different rows" do
        table_one = Table.new
        table_two = Table.new

        table_one.add_row "a"

        table_one.should_not == table_two
        table_two.should_not == table_one
      end

      it "should not be equal if the other object does not respond_to? :headings" do
        table_one = Table.new
        table_two = Object.new
        table_two.stub!(:rows).and_return([])
        table_one.should_not == table_two
      end

      it "should not be equal if the other object does not respond_to? :rows" do
        table_one = Table.new
        table_two = Object.new
        table_two.stub!(:rows).and_return([])
        table_one.should_not == table_two
      end
    end

    it "should handle colspan inside heading" do
      @table.headings = ['one', { :value => 'two', :alignment => :center, :colspan => 2}]
      @table.rows = [['a', 1, 2], ['b', 3, 4], ['c', 3, 4]]
      @table.render.should == <<-EOF.deindent
        +-----+---+---+
        | one |  two  |
        +-----+---+---+
        | a   | 1 | 2 |
        | b   | 3 | 4 |
        | c   | 3 | 4 |
        +-----+---+---+
      EOF
    end

    it "should handle colspan inside cells" do
      @table.headings = ['one', 'two', 'three']
      @table.rows = [['a', 1, 2], ['b', 3, 4], [{:value => "joined", :colspan => 2,:alignment => :center}, 'c']]
      @table.render.should == <<-EOF.deindent
        +-----+-----+-------+
        | one | two | three |
        +-----+-----+-------+
        | a   | 1   | 2     |
        | b   | 3   | 4     |
        |  joined   | c     |
        +-----+-----+-------+
      EOF
    end

    it "should handle colspan inside cells regardless of colspan position" do
      @table.headings = ['one', 'two', 'three']
      @table.rows = [['a', 1, 2], ['b', 3, 4], ['c', {:value => "joined", :colspan => 2,:alignment => :center}]]
      @table.render.should == <<-EOF.deindent
        +-----+-----+-------+
        | one | two | three |
        +-----+-----+-------+
        | a   | 1   | 2     |
        | b   | 3   | 4     |
        | c   |   joined    |
        +-----+-----+-------+
      EOF
    end

    it "should handle overflowing colspans" do
      @table.headings = ['one', 'two', 'three']
      @table.rows = [['a', 1, 2], ['b', 3, 4], ['c', {:value => "joined that is very very long", :colspan => 2,:alignment => :center}]]
      @table.render.should == <<-EOF.deindent
        +-----+---------------+---------------+
        | one | two           | three         |
        +-----+---------------+---------------+
        | a   | 1             | 2             |
        | b   | 3             | 4             |
        | c   | joined that is very very long |
        +-----+---------------+---------------+
      EOF
    end

    it "should only increase column size for multi-column if it is unavoidable" do
      @table << [12345,2,3]
      @table << [{:value => 123456789, :colspan => 2}, 4]
      @table.render.should == <<-EOF.deindent
        +-------+---+---+
        | 12345 | 2 | 3 |
        | 123456789 | 4 |
        +-------+---+---+
      EOF
    end


    it "should handle colspan 1" do
      @table.headings = ['name', { :value => 'values', :colspan => 1}]
      @table.rows = [['a', 1], ['b', 4], ['c', 7]]
      @table.render.should == <<-EOF.deindent
        +------+--------+
        | name | values |
        +------+--------+
        | a    | 1      |
        | b    | 4      |
        | c    | 7      |
        +------+--------+
      EOF
    end

    it "should handle big colspan" do
      @table.headings = ['name', { :value => 'values', :alignment => :right, :colspan => 3}]
      @table.headings = ['name', { :value => 'values', :colspan => 3}]
      @table.rows = [['a', 1, 2, 3], ['b', 4, 5, 6], ['c', 7, 8, 9]]
      
      @table.render.should == <<-EOF.deindent
        +------+---+---+---+
        | name | values    |
        +------+---+---+---+
        | a    | 1 | 2 | 3 |
        | b    | 4 | 5 | 6 |
        | c    | 7 | 8 | 9 |
        +------+---+---+---+
      EOF
    end
  end
end
