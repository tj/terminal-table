
module Terminal
  class Table
    class Cell
      
      attr_accessor :value, :alignment, :colspan
      
      def initialize width, params
        @width = width
        @alignment = :left
        @colspan = 1

        if params.is_a? Hash
          @value = params[:value]
          @alignment = params[:alignment] unless params[:alignment].nil?
          @colspan = params[:colspan] unless params[:colspan].nil?
        else
          @value = params
        end
      end
      
      def render
        " #{value.to_s} ".align alignment, @width + 2
      end
      alias :to_s :render
      
      def length
        @value.to_s.length + 2
      end
    end
  end
end