
module Terminal
  class Table
    class Cell
      
      attr_accessor :value, :alignment
      
      def initialize width, value = nil, alignment = :left
        @width, @alignment, @value = width, alignment, value
      end
      
      def render
        " #{value.to_s} ".align alignment, @width + 2
      end
      alias :to_s :render
      
      def length
        value.to_s.length + 2
      end
      
    end
  end
end