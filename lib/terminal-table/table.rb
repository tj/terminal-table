
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
      buffer = [separator, "\n"]
      if has_headings?
        buffer << render_headings
        buffer << "\n" << separator << "\n"
      end
      buffer << @rows.map do |row| 
        render_row(row)
      end.join("\n")
      buffer << "\n" << separator << "\n"
      buffer.join
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
          render_cell(cell, row_to_index(row, i))
        end.join(Y) + Y
      end
    end
    
    ##
    # Render the given _cell_ at index _i_.

    def render_cell cell, i
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
      headings_with_rows.map { |row| row_with_hash(row)[n] }.compact
    end

    def row_with_hash row
      # this method duplicates the multi-column columns in each column they are in
      index = 0
      row.inject [] do |columns, column|
        if column.is_a?(Hash) && column[:colspan] && column[:colspan] > 1
          column[:start_index] = index
          column[:colspan].times do
            columns << column
            index += 1
          end
        else
          columns << column
          index += 1
        end
        columns
      end
    end

    def row_to_index row, index
      new_index = -1
      0.upto(index) do |i|
        column = row[i]
        if column.is_a?(Hash) && column[:colspan] && column[:colspan] > 1 && index != i
          new_index = new_index + column[:colspan]
        else
          new_index += 1
        end
      end
      return new_index
    end
    
    ##
    # Return columns.
    
    def columns 
      (0...number_of_columns).map { |n| column n } 
    end
    
    ##
    # Return the length of the largest cell found within column _n_.

    def length_of_largest_cell_in_column n
      column_with_headings(n).map do |cell|
        if cell.is_a? Hash
          if cell[:colspan] && cell[:colspan] > 1
            if (cell[:value].to_s.length <= length_of_single_columns_where_multicolumn_is(cell[:start_index],cell[:colspan]))
              0
            else
              spacing_length = (3 * (cell[:colspan] - 1))
              length_in_columns = (cell[:value].to_s.length - spacing_length)
              (length_in_columns.to_f / cell[:colspan]).ceil
            end
          else
            cell[:value].to_s.length
          end
        else
          cell.to_s.length
        end
      end.sort.last
    end

    ##
    # Returns the length of the largest single column cell found within column _n_.

    def length_of_largest_single_column_cell_in_column n
      column_with_headings(n).map do |cell|
        if cell.is_a? Hash
          if cell[:colspan] && cell[:colspan] > 1
            0
          else
            cell[:value].to_s.length
          end
        else
          cell.to_s.length
        end
      end.sort.last
    end

    ##
    # Returns the length of the single columns starting from _n_ and going through _length_ columns.

    def length_of_single_columns_where_multicolumn_is(n,length)
      total_length = 0
      spacing_length = (3 * (length - 1))
      total_length = total_length + spacing_length
      n.upto(n + length - 1) do |i|
        total_length = total_length + length_of_largest_single_column_cell_in_column(i)
      end
      return total_length
    end
    
    ##
    # Return length of column _n_.
    
    def length_of_column n
      length_of_largest_cell_in_column n      
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
      r = rows
      column(n).each_with_index do |col, i|
        r[i][n] = { :value => col, :alignment => alignment } unless Hash === col
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
