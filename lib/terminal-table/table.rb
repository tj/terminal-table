
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
      @headings = options.delete(:headings) || []
      @rows = options.delete(:rows) || [] 
      yield_or_eval &block if block_given?
    end
    
    ##
    # Render the table. Often you will simply call _puts_ with an
    # instance in order to output it to the terminal.
  
    def render
      s = seperator + "\n" 
      s << Y + headings.collect_with_index { |h, i| Heading.new(length_of_column(i), h).render }.join(Y) + Y if has_headings?
      s << "\n" + seperator + "\n" if has_headings?
      s << rows.collect { |row| Y + row.collect_with_index { |c, i| Cell.new(length_of_column(i), c).render }.join(Y) + Y }.join("\n")
      s << "\n" + seperator + "\n"
    end
    alias :to_s :render
    
    ##
    # Create a seperator based on colum lengths.
    
    def seperator
      I + columns.collect_with_index { |col, i| X * (length_of_column(i) + 2) }.join(I) + I 
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
      rows.collect { |row| row[n] }.compact 
    end
    
    ##
    # Return +n+ column including headings.
    
    def column_with_headings n
      headings_with_rows.collect { |row| row[n] }.compact  
    end
    
    ##
    # Return columns.
    
    def columns 
      (0..number_of_columns-1).collect { |n| column n } 
    end
    
    ##
    # Return the largest cell found within column +n+.
    
    def largest_cell_in_column n
      column_with_headings(n).sort_by { |c| Cell.new(0, c).length }.last
    end
    
    ##
    # Return length of column +n+.
    
    def length_of_column n
      largest_cell_in_column(n).to_s.length
    end
    
    ##
    # Return total number of columns available.
     
    def number_of_columns
      if rows[0]
        rows[0].length 
      else
        raise Error, 'Your table needs some rows'
      end 
    end
    
    ##
    # Align column +n+ to +alignment+ of :center, :left, or :right.
    
    def align_column n, alignment
      column(n).each_with_index do |c, i|
        unless c.is_a? Hash
          @rows[i][n] = { :value => c, :align => alignment }
        end
      end
    end
    
    private
    
    ##
    # Return headings combined with rows.
    
    def headings_with_rows
      [headings] + rows
    end
    
  end
end