
require 'terminal-table/import'

describe Kernel do
  
  describe "#table" do
    it "should allow creation of a terminal table" do
      table(['foo', 'bar'], ['a', 'b'], [1, 2]).
      should be_instance_of(Terminal::Table)
    end
  end

end