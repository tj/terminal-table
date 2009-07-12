require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

module Terminal
  describe Table::TableHelper do
    before do
      @obj = Class.new do
        include Table::TableHelper
      end.new
    end

    describe "#table" do
      it "should allow creation of a terminal table" do
        table = @obj.table(['foo', 'bar'], ['a', 'b'], [1, 2])
        table.should be_instance_of(Terminal::Table)
      end
    end
  end
end
