
module Terminal
  class Table
    class Cell
      
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
      
      def initialize width, options = {}
        @width = width
        @alignment = :left
        @colspan = 1

        if options.is_a? Hash
          @value = options[:value]
          @alignment = options[:alignment] unless options[:alignment].nil?
          @colspan = options[:colspan] unless options[:colspan].nil?
        else
          @value = options
        end
      end
      
      ##
      # Render the cell.
      
      def render
        " #{value.to_s} ".align alignment, @width + 2
      end
      alias :to_s :render
      
      ##
      # Cell length.
      
      def length
        @value.to_s.length + 2
      end
    end
  end
end