module Terminal
  class Table
    class Separator < Row

      def initialize(*args)
        super
        @prevrow, @nextrow = nil, nil # references to adjacent rows.
      end

      def row_type
        return :top if @prevrow.nil?
        return :bot if @nextrow.nil?
        return :below_heading if @prevrow.is_a?(HeadingRow)
        :mid
      end
      
      def render
        left_edge, ctrflat, ctrud, right_edge, ctrdn, ctrup = @table.style.horizontal(row_type)
        #p [row_type, left_edge, ctrflat, ctrud, right_edge, ctrdn, ctrup, @prevrow.class, @nextrow.class]
        
        prev_crossings = @prevrow.respond_to?(:crossings) ? @prevrow.crossings : []
        next_crossings = @nextrow.respond_to?(:crossings) ? @nextrow.crossings : []
        rval = [left_edge]
        numcols = @table.number_of_columns
        (0...numcols).each do |idx|
          rval << ctrflat * (@table.column_width(idx) + @table.cell_padding)
          pcinc = prev_crossings.include?(idx+1)
          ncinc = next_crossings.include?(idx+1)
          border_center = if pcinc && ncinc
                            ctrud
                          elsif pcinc
                            ctrup
                          elsif ncinc
                            ctrdn
                          elsif !ctrud.empty?
                            # special case if the center-up-down intersection is empty
                            # which happens when verticals/intersections are removed. in that case
                            # we do not want to replace with a flat element so return empty-string in else block
                            ctrflat
                          else
                            ''
                          end
          rval << border_center if idx < numcols-1
        end
          
        rval << right_edge
        rval.join
      end

      # Save off neighboring rows, so that we can use them later in determining
      # which types of table edges to use.
      def save_adjacent_rows(prevrow, nextrow)
        @prevrow = prevrow
        @nextrow = nextrow
      end
      
    end
  end
end
