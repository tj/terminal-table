
module Terminal
  class Table
    
    #--
    # Exceptions
    #++
    
    Error = Class.new StandardError
    
    ##
    # Table characters, x axis, y axis, and intersection.
    
    X, Y, I = '-', '|', '+'
    
    attr_reader :title
    attr_reader :headings
    attr_accessor :width
    
    ##
    # Generates a ASCII table with the given _options_.
  
    def initialize options = {}, &block
      @column_widths = []
      self.headings = options.fetch :headings, []
      @rows = []
      @width = options[:width]
      options.fetch(:rows, []).each { |row| add_row row }
      yield_or_eval(&block) if block
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
    # Add a row. 
    
    def add_row array
      @rows << Row.new(self, array)
      recalc_column_widths @rows.last
    end
    alias :<< :add_row

    ##
    # Add a separator.

    def add_separator
      self << :separator
    end

    ##
    # Return column _n_.
    
    def column n, method = :value, array = rows
      array.map { |row| 
        cell = row[n]
        cell && method ? cell.__send__(method) : cell
      }.compact 
    end
    
    ##
    # Return _n_ column including headings.
    
    def column_with_headings n, method = :value
      column n, method, headings_with_rows
    end
    
    ##
    # Return columns.
    
    def columns
      (0...number_of_columns).map { |n| column n } 
    end
    
    ##
    # Return length of column _n_.
    
    def column_width n
      width = @column_widths[n] || 0
      width + additional_column_widths[n].to_i
    end
    alias length_of_column column_width # for legacy support
    
    ##
    # Return total number of columns available.
     
    def number_of_columns
      if rows.empty?
        raise Error, 'your table needs some rows'
      else
        rows.map { |r| r.size }.max
      end
    end

    ##
    # Set the headings
    
    def headings= array
      @headings = Row.new(self, array)
      recalc_column_widths @headings
    end

    ##
    # Render the table.
  
    def render
      @seperator = nil
      buffer = [separator]
      unless @title.nil?
        opts = {:value => @title, :alignment => :center, :colspan => number_of_columns}
        buffer << Row.new(self, [opts]).render
        buffer << separator
      end
      unless @headings.empty?
        buffer << @headings.render
        buffer << separator
      end
      buffer += @rows.map do |row| 
        row.render
      end
      buffer << separator
      buffer.join("\n")
    end
    alias :to_s :render
    
    ##
    # Return rows without separator rows.

    def rows
      @rows.reject { |row| row.separator? }
    end
    
    def rows= array
      array.each { |arr| self << arr }
    end

    ##
    # Create a separator based on colum lengths.
    
    def separator
      @separator ||= begin
        I + (0...number_of_columns).to_a.map do |i|
          X * (column_width(i) + 2) 
        end.join(I) + I 
      end
    end
    
    def title=(title)
      @title = title
      recalc_column_widths Row.new(self, [title])
    end
    
    ##
    # Check if _other_ is equal to self. _other_ is considered equal
    # if it contains the same headings and rows.

    def == other
      if other.respond_to? :render and other.respond_to? :rows
        self.headings == other.headings and self.rows == other.rows
      end
    end

    private
    
    def columns_width
      @column_widths.inject(0) { |s, i| s + i + 2 + Y.length } + Y.length
    end
    
    def additional_column_widths
      return [] if @width.nil?
      spacing = @width - columns_width
      if spacing < 0
        raise "Table width exceeds wanted width of #{wanted} characters."
      else
        per_col = spacing / number_of_columns
        arr = (1...number_of_columns).to_a.map { |i| per_col }
        other_cols = arr.inject(0) { |s, i| s + i }
        arr << spacing - other_cols
        arr
      end
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
    
    ##
    # Return headings combined with rows.
    
    def headings_with_rows
      [@headings] + rows
    end
    
    def yield_or_eval &block
      return unless block
      if block.arity > 0
        yield self
      else
        self.instance_eval(&block)
      end
    end
  end
end
