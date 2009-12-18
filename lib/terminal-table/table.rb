
module Terminal
  
  ##
  # Generates an ASCII table for terminal usage.
  #
  # This class can be used in many ways, however ultimately you should
  # require 'terminal-table/import' (which requires terminal-table itself) to use
  # the Kernel helper method which is easier, and cleaner to use. View Object#table
  # for examples.
  #
  # === Examples:
  #
  #    table = Terminal::Table.new
  #    table.headings = ['Characters', { :value => 'Nums', :align => :right }]
  #    table << [{ :value => 'a', :align => :center }, 1]
  #    table << ['b', 222222222222222]
  #    table << ['c', 3]
  #    puts table.render     # or simply puts table
  #
  #    +------------+-----------------+
  #    | Characters |            Nums |
  #    +------------+-----------------+
  #    |     a      | 1               |
  #    | b          | 222222222222222 |
  #    | c          | 3               |
  #    +------------+-----------------+
  #    
  
  class Table
    
    #--
    # Exceptions
    #++
    
    class Error < StandardError; end
    
    ##
    # Table characters, x axis, y axis, and intersection.
    
    X, Y, I = '-', '|', '+'
    
    attr_accessor :headings, :rows
    
    ##
    # Generates a ASCII table.
  
    def initialize options = {}, &block
      @headings = options.fetch :headings, []
      @rows = options.fetch :rows, []
      yield_or_eval &block if block_given?
    end
    
    ##
    # Render the table. Often you will simply call _puts_ with an
    # instance in order to output it to the terminal.
  
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

    def render_row(row)
      if row.is_a?(Separator)
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
      @rows << Separator.new
    end

    ##
    # Weither or not any headings are present, since they are optional.
    
    def has_headings?
      !headings.empty?
    end
    
    ##
    # Return +n+ column.
    
    def column n
      rows.map { |row| row[n] }.compact 
    end
    
    ##
    # Return +n+ column including headings.
    
    def column_with_headings n
      headings_with_rows.map { |row| row[n] }.compact  
    end
    
    ##
    # Return columns.
    
    def columns 
      (0..number_of_columns-1).map { |n| column n } 
    end
    
    ##
    # Return the largest cell found within column +n+.
    
    def largest_cell_in_column n
      column_with_headings(n).sort_by { |cell| Cell.new(0, cell).length }.last
    end
    
    ##
    # Return length of column +n+.
    
    def length_of_column n
      largest_cell = largest_cell_in_column(n)
      if largest_cell.is_a? Hash
        largest_cell[:value].length# - 2
      else
        largest_cell.to_s.length
      end
    end
    
    ##
    # Return total number of columns available.
     
    def number_of_columns
      return rows.first.length unless rows.empty?
      raise Error, 'your table needs some rows.'
    end
    
    ##
    # Align column +n+ to +alignment+ of :center, :left, or :right.
    
    def align_column n, alignment
      column(n).each_with_index do |col, i|
        @rows[i][n] = {:value => col, :alignment => alignment} unless col.is_a? Hash
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
      @rows.reject { |row| row.is_a?(Separator) }
    end

    ##
    # Return rows including separator rows.

    def all_rows
      @rows
    end

    ##
    # Check if +other+ is equal to self. +other+ is considered equal
    # if it contains the same headings and rows.

    def == other
      if other.respond_to?(:headings) && other.respond_to?(:rows)
        headings == other.headings && rows == other.rows
      end
    end
  end
end
