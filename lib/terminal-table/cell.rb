
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
      # Column span.
      
      attr_reader :colspan
      
      ##
      # Initialize with _options_.
      
      def initialize options = nil
        @value, options = options, {} unless Hash === options
        @value = options.fetch :value, value
        @alignment = options.fetch :alignment, nil
        @colspan = options.fetch :colspan, 1
        @width = options.fetch :width, @value.to_s.size
        @index = options.fetch :index
        @table = options.fetch :table
      end
      
      def alignment?
        !@alignment.nil?
      end
      
      def alignment
        @alignment || :left
      end
      
      def alignment=(val)
        supported = %w(left center right)
        if supported.include?(val.to_s)
          @alignment = val
        else
          raise "Aligment must be one of: #{supported.join(' ')}"
        end
      end
      
      def lines
        @value.to_s.split(/\n/)
      end
      
      ##
      # Render the cell.
      
      def render(line = 0)
        left = " " * @table.style.padding_left
        right = " " * @table.style.padding_right
        render_width = lines[line].to_s.size - escape(lines[line]).size + width
        "#{left}#{lines[line]}#{right}".align(alignment, render_width + @table.cell_padding)
      end
      alias :to_s :render
      
      ##
      # Returns the longest line in the cell and
      # removes all ANSI escape sequences (e.g. color)
      
      def value_for_column_width_recalc
        lines.map{ |s| escape(s) }.max_by{ |s| s.size }
      end
      
      ##
      # Returns the width of this cell
      
      def width
        padding = (colspan - 1) * @table.cell_spacing
        inner_width = (1..@colspan).to_a.inject(0) do |w, counter|
          w + @table.column_width(@index + counter - 1)
        end
        inner_width + padding
      end

      ##
      # removes all ANSI escape sequences (e.g. color)      
      def escape(line)
        line.to_s.gsub(/\x1b(\[|\(|\))[;?0-9]*[0-9A-Za-z]/, '').
          gsub(/\x1b(\[|\(|\))[;?0-9]*[0-9A-Za-z]/, '').
          gsub(/[\x03|\x1a]/, '')
      end
    end
  end
end
