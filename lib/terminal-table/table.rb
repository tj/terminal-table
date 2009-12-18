
module Terminal
  class Table
    
    #--
    # Exceptions
    #++
    
    Error = Class.new StandardError
    
    ##
    # Table characters, x axis, y axis, and intersection.
    
    X, Y, I = '-', '|', '+'
    
    ##
    # Headings array.
    
    attr_accessor :headings
    
    ##
    # Rows array.
    
    attr_accessor :rows
    
    ##
    # Generates a ASCII table with the given _options_.
  
    def initialize options = {}, &block
      @headings = options.fetch :headings, []
      @rows = options.fetch :rows, []
      yield_or_eval &block if block
    end
    
    ##
    # Render the table.
  
    def render
      buffer = separator << "\n"
      if has_headings?
        buffer << render_headings
        buffer << "\n#{separator}\n"
      end
      buffer << @rows.map do |row| 
        render_row(row)
      end.join("\n")
      buffer << "\n#{separator}\n"
    end
    alias :to_s :render
    
    ##
    # Render headings.

    def render_headings
      Y + headings.map_with_index do |heading, i|
        width = 0
        if heading.is_a?(Hash) and !heading[:colspan].nil?
          i.upto(i + heading[:colspan] - 1) do |col|
            width += length_of_column(col)
          end
          width += (heading[:colspan] - 1) * (Y.length + 2)
        else
          width = length_of_column(i)
        end
        Heading.new( width, heading).render
      end.join(Y) + Y
    end
    
    ##
    # Render the given _row_.

    def render_row row
      if row == :separator
        separator
      else
        Y + row.map_with_index do |cell, i|
          render_cell(cell, i)
        end.join(Y) + Y
      end
    end

    def render_cell(cell, i)
      width = 0
      if cell.is_a?(Hash) and !cell[:colspan].nil?
        i.upto(i + cell[:colspan] - 1) do |col|
          width += length_of_column(col)
        end
        width += (cell[:colspan] - 1) * (Y.length + 2)
      else
        width = length_of_column(i)
      end
      Cell.new(width, cell).render
    end
    
    ##
    # Create a separator based on colum lengths.
    
    def separator
      I + columns.collect_with_index do |col, i| 
        X * (length_of_column(i) + 2) 
      end.join(I) + I 
    end
    
    ##
    # Add a row. 
    
    def add_row row
      @rows << row
    end
    alias :<< :add_row

    ##
    # Add a separator.

    def add_separator
      @rows << :separator
    end

    ##
    # Weither or not any headings are present, since they are optional.
    
    def has_headings?
      not headings.empty?
    end
    
    ##
    # Return column _n_.
    
    def column n
      rows.map { |row| row[n] }.compact 
    end
    
    ##
    # Return _n_ column including headings.
    
    def column_with_headings n
      headings_with_rows.map { |row| row[n] }.compact  
    end
    
    ##
    # Return columns.
    
    def columns 
      (0...number_of_columns).map { |n| column n } 
    end
    
    ##
    # Return the largest cell found within column _n_.
    
    def largest_cell_in_column n
      column_with_headings(n).sort_by do |cell| 
        Cell.new(0, cell).length 
      end.last
    end
    
    ##
    # Return length of column _n_.
    
    def length_of_column n
      largest_cell = largest_cell_in_column n
      Hash === largest_cell ?
        largest_cell[:value].to_s.length :
          largest_cell.to_s.length
    end
    
    ##
    # Return total number of columns available.
     
    def number_of_columns
      return rows.first.length unless rows.empty?
      raise Error, 'your table needs some rows'
    end
    
    ##
    # Align column _n_ to the given _alignment_ of :center, :left, or :right.
    
    def align_column n, alignment
      column(n).each_with_index do |col, i|
        @rows[i][n] = { :value => col, :alignment => alignment } unless Hash === col
      end
    end
    
    ##
    # Return headings combined with rows.
    
    def headings_with_rows
      [headings] + rows
    end

    ##
    # Return rows without separator rows.

    def rows
      @rows.reject { |row| row == :separator }
    end

    ##
    # Return rows including separator rows.

    def all_rows
      @rows
    end

    ##
    # Check if _other_ is equal to self. _other_ is considered equal
    # if it contains the same headings and rows.

    def == other
      if other.respond_to? :headings and other.respond_to? :rows
        headings == other.headings and rows == other.rows
      end
    end
  end
end
