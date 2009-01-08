
module Terminal
  class Table
    
    X, Y, I = '-', '|', '+'
    
    attr_accessor :headings, :rows
  
    def initialize options = {}
      @headings = options.delete(:headings) || []
      @rows = options.delete(:rows) || []
    end
  
    def add_row row
      @rows << row
    end
    alias :<< :add_row
  
    def render
      
    end
    alias :to_s :render
    
    def has_headings?
      !@headings.empty?
    end
    
    def has_rows?
      !@rows.empty?
    end
    
    def align_column n, alignment
      
    end
    
  end
end