
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
    # Rows array.
    
    attr_accessor :rows
    
    attr_reader :headings
    
    ##
    # Generates a ASCII table with the given _options_.
  
    def initialize options = {}, &block
      @column_widths = []
      self.headings = options.fetch :headings, []
      @rows = []
      options.fetch(:rows, []).each { |row| add_row row }
      yield_or_eval &block if block
    end

    def headings= array
      @headings = Row.new(self, array)
      recalc_column_widths @headings
    end

    ##
    # Render the table.
  
    def render
      buffer = [separator, "\n"]
      if has_headings?
        buffer << @headings.render
        buffer << "\n" << separator << "\n"
      end
      buffer << @rows.map do |row| 
        row.render
      end.join("\n")
      buffer << "\n" << separator << "\n"
      buffer.join
    end
    alias :to_s :render
    
    def rows= array
      array.each { |arr| self << arr }
    end
    
    ##
    # Create a separator based on colum lengths.
    
    def separator
      I + columns.collect_with_index do |col, i| 
        X * (column_width(i) + 2) 
      end.join(I) + I 
    end
    
    ##
    # Add a row. 
    
    def add_row array
      @rows << Row.new(self, array)
      recalc_column_widths @rows.last
    end

    def recalc_column_widths row
      if row.is_a?(Symbol) then return end
      i = 0
      row.each do |cell|
        colspan = cell.colspan
        cell_value = cell.value_for_column_width_recalc
        colspan.downto(1) do |j|
          cell_length = cell_value.to_s.length
          if colspan > 1
            spacing_length = (3 * (colspan - 1))
            length_in_columns = (cell_length - spacing_length)
            cell_length = (length_in_columns.to_f / colspan).ceil
          end
          if @column_widths[i].to_i < cell_length
            @column_widths[i] = cell_length
          end
          i = i + 1
        end
      end
    end
    alias :<< :add_row

    ##
    # Add a separator.

    def add_separator
      @rows << Row.new(self, :separator)
    end

    ##
    # Weither or not any headings are present, since they are optional.
    
    def has_headings?
      not @headings.empty?
    end
    
    ##
    # Return column _n_.
    
    def column n
      rows.map { |row| 
        row[n] 
      }.compact 
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
    # Return length of column _n_.
    
    def column_width n
      @column_widths[n] || 0
    end
    alias length_of_column column_width # for legacy support
    
    ##
    # Return total number of columns available.
     
    def number_of_columns
      if rows.empty?
        raise Error, 'your table needs some rows'
      else
        rows.first.size
      end
    end
    
    ##
    # Align column _n_ to the given _alignment_ of :center, :left, or :right.
    
    def align_column n, alignment
      r = rows
      column(n).each_with_index do |col, i|
        r[i][n].alignment = alignment
      end
    end
    
    ##
    # Return headings combined with rows.
    
    def headings_with_rows
      [@headings] + rows
    end

    ##
    # Return rows without separator rows.

    def rows
      @rows.reject { |row| row.separator? }
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
        @headings == other.headings and rows == other.rows
      end
    end
  end
end

if __FILE__ == $0
  require File.join(File.dirname(__FILE__), '..', '..', 'examples', 'examples')
end