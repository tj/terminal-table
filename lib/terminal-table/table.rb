
module Terminal
  class Table
    
    ##
    # Table characters, x axis, y axis, and intersection.
    
    X, Y, I = '-', '|', '+'
    
    ##
    # Space applied twice to each cell (left and right)
    
    PADDING = 1
    
    attr_accessor :headings, :rows
  
    def initialize options = {}
      @headings = options.delete(:headings) || []
      @rows = options.delete(:rows) || []
    end
  
    def render
      s = "\n" << seperator << "\n"
      s << headings.collect { |heading| Heading.new(heading).render }.join(Y) if has_headings?
      s << rows.collect { |row| row.collect { |cell| Cell.new(cell).render }.join(Y) }.join("\n")
      s << seperator << "\n"
      puts s
    end
    alias :to_s :render
    
    def seperator
      @seperator ||= I + largest.collect { |cell| X * Cell.new(cell).length }.join(I) + I
    end
    
    def add_row row
      rows << row
    end
    alias :<< :add_row
    
    def largest
      [largest_row, headings].sort.first
    end
    
    def largest_row
      rows.sort_by { |row| row.join.length }.last 
    end
    
    def has_headings?
      !headings.empty?
    end
    
    def align_column n, alignment
      
    end
    
  end
end