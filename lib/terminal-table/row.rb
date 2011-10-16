
require File.join(File.dirname(__FILE__), 'table')

module Terminal
  class Table
    class Row
      include Enumerable
      X, Y, I = Terminal::Table::X, Terminal::Table::Y, Terminal::Table::I
      
      ##
      # Row cells
      
      attr_reader :cells
      
      attr_reader :table
      
      ##
      # Initialize with _width_ and _options_.
      
      def initialize table, array
        @table = table
        @cells = array
      end
      
      def [] index
        cells[index] unless separator?
      end
      
      def []= index, value
        cells[index] = value
      end
      
      def each &block
        cells.each &block
      end
      
      def method_missing m, &block
        if cells.respond_to?(m)
          cells.__send__(m, &block)
        else
          super
        end
      end
      
      def render
        
      end
      
      def separator?
        cells == :separator
      end
      
    end
  end
end