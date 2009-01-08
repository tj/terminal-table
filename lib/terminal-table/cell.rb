
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
      
    end
  end
end