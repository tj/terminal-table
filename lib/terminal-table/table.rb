require 'unicode/display_width'

module Terminal
  class Table

    attr_reader :title
    attr_reader :headings

    ##
    # Generates a ASCII table with the given _options_.

    def initialize options = {}, &block
      @column_widths = []
      self.style = options.fetch :style, {}
      self.headings = options.fetch :headings, []
      self.rows = options.fetch :rows, []
      self.title = options.fetch :title, nil
      yield_or_eval(&block) if block
    end

    ##
    # Align column _n_ to the given _alignment_ of :center, :left, or :right.

    def align_column n, alignment
      r = rows
      column(n).each_with_index do |col, i|
        cell = r[i][n]
        cell.alignment = alignment unless cell.alignment?
      end
    end

    ##
    # Add a row.

    def add_row array
      row = array == :separator ? Separator.new(self) : Row.new(self, array)
      @rows << row
      recalc_column_widths row
    end
    alias :<< :add_row

    ##
    # Add a separator.

    def add_separator
      self << :separator
    end

    def cell_spacing
      cell_padding + style.border_y.length
    end

    def cell_padding
      style.padding_left + style.padding_right
    end

    ##
    # Return column _n_.

    def column n, method = :value, array = rows
      array.map { |row|
        # for each cells in a row, find the column with index
        # just greater than the required one, and go back one.
        index = col = 0
        row.cells.each do |cell|
          break if index > n
          index += cell.colspan
          col += 1
        end
        cell = row[col - 1]
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
      headings_with_rows.map { |r| r.cells.size }.max
    end

    ##
    # Set the headings

    def headings= arrays
      arrays = [arrays] unless arrays.first.is_a?(Array)
      @headings = arrays.map do |array|
        row = Row.new(self, array)
        recalc_column_widths row
        row
      end
    end

    ##
    # Render the table.

    def render
      separator = Separator.new(self)
      buffer = [separator]
      unless @title.nil?
        buffer << Row.new(self, [title_cell_options])
        buffer << separator
      end
      @headings.each do |row|
        unless row.cells.empty?
          buffer << row
          buffer << separator
        end
      end
      if style.all_separators
        buffer += @rows.product([separator]).flatten
      else
        buffer += @rows
        buffer << separator
      end
      buffer.map { |r| style.margin_left + r.render.rstrip }.join("\n")
    end
    alias :to_s :render

    ##
    # Return rows without separator rows.

    def rows
      @rows.reject { |row| row.is_a? Separator }
    end

    def rows= array
      @rows = []
      array.each { |arr| self << arr }
    end

    def style=(options)
      style.apply options
    end

    def style
      @style ||= Style.new
    end

    def title=(title)
      @title = title
      recalc_column_widths Row.new(self, [title_cell_options])
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
      @column_widths.inject(0) { |s, i| s + i + cell_spacing } + style.border_y.length
    end

    def additional_column_widths
      return [] if style.width.nil?
      spacing = style.width - columns_width
      if spacing < 0
        raise "Table width exceeds wanted width of #{style.width} characters."
      else
        per_col = spacing / number_of_columns
        arr = (1...number_of_columns).to_a.map { |i| per_col }
        other_cols = arr.inject(0) { |s, i| s + i }
        arr << spacing - other_cols
        arr
      end
    end

    def recalc_column_widths row
      return if row.is_a? Separator
      i = 0
      row.cells.each do |cell|
        colspan = cell.colspan
        cell_value = cell.value_for_column_width_recalc
        colspan.downto(1) do |j|
          cell_length = Unicode::DisplayWidth.of(cell_value.to_s)
          if colspan > 1
            spacing_length = cell_spacing * (colspan - 1)
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
      @headings + rows
    end

    def yield_or_eval &block
      return unless block
      if block.arity > 0
        yield self
      else
        self.instance_eval(&block)
      end
    end

    def title_cell_options
      {:value => @title, :alignment => :center, :colspan => number_of_columns}
    end
  end
end
