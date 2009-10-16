
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
      
      attr_reader :alignment
      
      ##
      # Column span.
      
      attr_reader :colspan
      
      ##
      # Initialize with _width_ and _options_.
      
      def initialize width, options = nil
        @width = width
        @value, options = options, {} unless Hash === options
        @value = options.fetch :value, value
        @alignment = options.fetch :alignment, :left
        @colspan = options.fetch :colspan, 1
      end
      
      ##
      # Render the cell.
      
      def render
        " #{value} ".align alignment, width + 2
      end
      alias :to_s :render
      
      ##
      # Cell length.
      
      def length
        value.to_s.length + 2
      end
    end
  end
end