
module Terminal
  class Table
    class Cell
      
      DEFAULT_ALIGNMENT = :left
      
      attr_accessor :value, :alignment
      
      def initialize initial = nil
        case initial
        when Hash
          @value = initial[:value]
          @alignment = initial[:align] unless initial[:align].nil?
        when
          @value = initial
          @alignment = DEFAULT_ALIGNMENT
        end
      end
      
      def render
        value.to_s.align alignment, length
      end
      alias :to_s :render
      
      def length
        (PADDING * 2) + value.to_s.length
      end
      
    end
  end
end