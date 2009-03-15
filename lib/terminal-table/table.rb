
module Terminal
  
  ##
  # Generates an ASCII table for terminal usage.
  #
  # This class can be used in many ways, however ultimately you should
  # require 'terminal-table/import' (which requires terminal-table itself) to use
  # the Kernel helper method which is easier, and cleaner to use. View Kernel#table
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
      buffer = seperator << "\n" 
      if has_headings?
        buffer << Y + headings.map_with_index do |heading, i| 
          Heading.new(length_of_column(i), *heading).render 
        end.join(Y) + Y
        buffer << "\n#{seperator}\n"
      end
      buffer << rows.map do |row| 
        Y + row.map_with_index do |cell, i|
          Cell.new(length_of_column(i), *cell).render 
        end.join(Y) + Y 
      end.join("\n")
      buffer << "\n#{seperator}\n"
    end
    alias :to_s :render
    
    ##
    # Create a seperator based on colum lengths.
    
    def seperator
      I + columns.collect_with_index do |col, i| 
        X * (length_of_column(i) + 2) 
      end.join(I) + I 
    end
    
    ##
    # Add a row. 
    
    def add_row row
      rows << row
    end
    alias :<< :add_row

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
      column_with_headings(n).sort_by { |cell| Cell.new(0, *cell).length }.last
    end
    
    ##
    # Return length of column +n+.
    
    def length_of_column n
      largest_cell_in_column(n).to_s.length
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
        @rows[i][n] = [col, alignment] unless col.is_a? Array
      end
    end
    
    ##
    # Return headings combined with rows.
    
    def headings_with_rows
      [headings] + rows
    end
    
  end
end