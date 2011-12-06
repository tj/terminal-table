require 'rubygems'
require 'term/ansicolor'

class String; include Term::ANSIColor; end

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
  
  it "should allow :left, :right and :center for alignment" do
    @cell = Cell.new :value => 'foo', :table => Terminal::Table.new, :index => 0
    @cell.alignment = :left
    @cell.alignment = :right
    @cell.alignment = :center
    lambda { @cell.alignment = "foo" }.should raise_error
  end
  
  it "should allow multiline content" do
    cell = Cell.new :value => "barrissimo\n"+"foo".yellow, :table => Terminal::Table.new, :index => 0
    cell.value.should == "barrissimo\n"+"foo".yellow
    cell.lines.should == ['barrissimo','foo'.yellow]
    cell.value_for_column_width_recalc.should == 'barrissimo'
    cell.render(0).should == " barrissimo "
  end
  
  it "should allow colorized content" do
    cell = Cell.new :value => "foo".red, :table => Terminal::Table.new, :index => 0
    cell.value.should == "\e[31mfoo\e[0m"
    cell.value_for_column_width_recalc.should == 'foo'
    cell.render.should == " \e[31mfoo\e[0m "
  end
  
  it "should render padding properly" do
    @table = Terminal::Table.new(:rows => [['foo', '2'], ['3', '4']], :style => {:padding_right => 3})
    cell = @table.rows.first.cells.first
    cell.value.should == 'foo'
    cell.alignment.should == :left
    cell.render.should == " foo   "
  end

end
