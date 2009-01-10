
module Terminal
  class Table
    
    ##
    # Table characters, x axis, y axis, and intersection.
    
    X, Y, I = '-', '|', '+'
    
    attr_accessor :headings, :rows
  
    def initialize options = {}
      @headings = options.delete(:headings) || []
      @rows = options.delete(:rows) || []
    end
  
    def render
      sep = seperator
      s = sep + "\n" 
      s << Y + headings.collect_with_index { |h, i| Heading.new(length_of_column(i), h).render }.join(Y) + Y if has_headings?
      s << "\n" + sep + "\n" if has_headings?
      s << rows.collect { |row| Y + row.collect_with_index { |c, i| Cell.new(length_of_column(i), c).render }.join(Y) + Y }.join("\n")
      s << "\n" + sep + "\n"
    end
    alias :to_s :render
    
    def seperator
      I + columns.collect_with_index { |col, i| X * (length_of_column(i) + 2) }.join(I) + I 
    end
    
    def add_row row
      rows << row
    end
    alias :<< :add_row

    def has_headings?
      !headings.empty?
    end
    
    def column n
      ([headings] + rows).collect { |row| row[n] }.compact 
    end
    
    def columns 
      (0..number_of_columns-1).collect { |n| column n } 
    end
    
    def largest_cell_in_column n
      column(n).sort_by { |c| Cell.new(0, c).length }.last
    end
    
    # FIXME: should not need rescue ... cannot compare array to array use length
    def length_of_column n
      largest_cell_in_column(n).to_s.length
    end
     
    def number_of_columns 
      rows[0].length
    end
    
    def align_column n, alignment
      columns.each_with_index do |col, i|
        col.each_with_index do |cell, j|
          value = cell.is_a?(Hash) ? cell[:value] : cell
          @rows[j][i] = { :value => value, :align => alignment }
        end
      end
    end
    
  end
end