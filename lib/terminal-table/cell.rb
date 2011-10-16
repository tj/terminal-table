
module Terminal
  class Table
    class Cell
      
      ##
      # Cell width.
      
      attr_reader :width
      
      ##
      # Cell value.
      
      attr_reader :value
      
      ##
      # Cell alignment.
      
      attr_accessor :alignment
      
      ##
      # Column span.
      
      attr_reader :colspan
      
      ##
      # Initialize with _options_.
      
      def initialize options = nil
        @value, options = options, {} unless Hash === options
        @value = options.fetch :value, value
        @alignment = options.fetch :alignment, :left
        @colspan = options.fetch :colspan, 1
        @width = options.fetch :width, @value.to_s.size
        @index = options.fetch :index
        @table = options.fetch :table
      end
      
      ##
      # Render the cell.
      
      def render(line = 0)
        " #{lines[line]} ".align alignment, width + 2
      end
      alias :to_s :render
      
      def lines
        @value.to_s.split(/\n/)
      end
      
      def value_for_column_width_recalc
        lines.sort.last
      end
      
      def width
        padding = (colspan - 1) * 3
        inner_width = (1..@colspan).to_a.inject(0) do |w, counter|
          w + @table.column_width(@index + counter - 1)
        end
        inner_width + padding
      end
      
      ##
      # Cell length.
      
      def length
        value.to_s.size + 2
      end
    end
  end
end