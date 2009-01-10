
module Terminal
  class Table
    class Cell
      
      DEFAULT_ALIGNMENT = :left
      
      attr_accessor :value, :alignment
      
      def initialize render_length, initial = nil
        @render_length = render_length
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
        " #{value.to_s} ".align alignment, @render_length + 2
      end
      alias :to_s :render
      
      def length
        value.to_s.length + 2
      end
      
    end
  end
end