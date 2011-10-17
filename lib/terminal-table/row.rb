module Terminal
  class Table
    class Row
      include Enumerable
      
      ##
      # Row cells
      
      attr_reader :cells
      
      attr_reader :table
      
      ##
      # Initialize with _width_ and _options_.
      
      def initialize table, array
        @table = table
        @cells = if array == :separator
          array
        else
          index = 0
          array.map do |item| 
            options = item.is_a?(Hash) ? item : {:value => item, :index => index}
            cell = Cell.new(options.merge(:index => index, :table => @table))
            index += cell.colspan
            cell
          end
        end
      end
      
      def [] index
        cells[index] unless separator?
      end
      
      def []= index, value
        cells[index] = value
      end
      
      def each &block
        cells.each &block unless separator?
      end
      
      def height
        cells.map { |c| c.lines.count }.max
      end
      
      def method_missing m, *args, &block
        if cells.respond_to?(m)
          cells.__send__(m, *args, &block)
        else
          super
        end
      end
      
      def render
        y = Terminal::Table::Y
        if separator?
          @table.separator
        else
          (0...height).to_a.map do |line|
            y + self.map_with_index do |cell, i|
              cell.render(line)
            end.join(y) + y
          end.join("\n")
        end
      end
      
      def separator?
        cells == :separator
      end
    end
  end
end