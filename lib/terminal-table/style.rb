# coding: utf-8
module Terminal
  class Table
    # A Style object holds all the formatting information for a Table object
    #
    # To create a table with a certain style, use either the constructor
    # option <tt>:style</tt>, the Table#style object or the Table#style= method
    #
    # All these examples have the same effect:
    #
    #     # by constructor
    #     @table = Table.new(:style => {:padding_left => 2, :width => 40})
    #
    #     # by object
    #     @table.style.padding_left = 2
    #     @table.style.width = 40
    #
    #     # by method
    #     @table.style = {:padding_left => 2, :width => 40}
    #
    # To set a default style for all tables created afterwards use Style.defaults=
    #
    #     Terminal::Table::Style.defaults = {:width => 80}
    #
    class Border
      attr_accessor :data
      def []=(key, val)
        @data[key] = val
      end
      def [](key)
        @data[key]
      end
      def initialize_dup(other)
        super
        @data = other.data.dup
      end
      def remove_verticals 
        self.class.const_get("VERTICALS").each { |key| @data[key] = "" }
        self.class.const_get("INTERSECTIONS").each { |key| @data[key] = "" }
      end
      def remove_horizontals 
        self.class.const_get("HORIZONTALS").each { |key| @data[key] = "" }
      end
    end
    
    class AsciiBorder < Border
      HORIZONTALS = %i[border_x]
      VERTICALS = %i[border_y]
      INTERSECTIONS = %i[border_i]
      
      def initialize
        @data = { border_x: "-", border_y: "|", border_i:  "+" }
      end
      
      # @return [Array] 3-element list of [left, center, right]
      def vertical
        y = @data[:border_y]
        [y, y, y] # left, center, right
      end
      
      # @return [Array] a 6 element list of: [i-left, horizontal-bar, i-up/down, i-right, i-down, i-up]
      def horizontal(_type)
        x, i = @data[:border_x], @data[:border_i]
        [i, x, i, i, i, i]
      end
    end
    
    class UnicodeBorder < Border
      HORIZONTALS = %i[border_x border_sx border_hx border_nx]
      VERTICALS = %i[border_y border_yw border_ye]
      INTERSECTIONS = %i[border_nw border_n border_ne border_nd 
                         border_hw border_hi border_he border_hd border_hu
                         border_w border_i border_e border_dn border_up 
                         border_sw border_s border_se border_su]
      def initialize 
        @data = {
          border_nw: "┌", border_nx: "─", border_n:  "┬", border_ne: "┐", border_nd: nil,
          border_yw: "│",                 border_y:  "│", border_ye: "│", 
          border_hw: "╞", border_hx: "═", border_hi: "╪", border_he: "╡", border_hd: '╤', border_hu: "╧",
          border_w:  "├", border_x:  "─", border_i:  "┼", border_e:  "┤", border_dn: "┬", border_up: "┴",
          border_sw: "└", border_sx: "─", border_s:  "┴", border_se: "┘", border_su:  nil,
        }
      end
      # @return [Array] 3-element list of [left, center, right]
      def vertical
        [@data[:border_yw], @data[:border_y], @data[:border_ye]] 
      end

      # @return [Array] a 6 element list of: [i-left, horizontal-bar, i-up/down, i-right, i-down, i-up]
      def horizontal(type)
        case type
        when :below_heading
          [@data[:border_hw], @data[:border_hx], @data[:border_hi], @data[:border_he], @data[:border_hd] || @data[:border_dn], @data[:border_hu] || @data[:border_up] ]
        when :top
          [@data[:border_nw], @data[:border_nx], @data[:border_n], @data[:border_ne], @data[:border_nd] || @data[:border_dn], nil ]
        when :bot
          [@data[:border_sw], @data[:border_sx], @data[:border_s], @data[:border_se], nil, @data[:border_su] || @data[:border_up] ]
        else # center
          [@data[:border_w], @data[:border_x], @data[:border_i], @data[:border_e], @data[:border_dn], @data[:border_up] ]
        end
      end
    end
    
    class Style
      @@defaults = {
        :border => AsciiBorder.new,
        :border_top => true, :border_bottom => true,
        :padding_left => 1, :padding_right => 1,
        :margin_left => '',
        :width => nil, :alignment => nil,
        :all_separators => false,
      }
      #@@defaults.merge!(@@ascii_borders)

      def border_x=(val)
        @border[:border_x] = val
      end
      def border_y=(val)
        @border[:border_y] = val
      end
      def border_i=(val)
        @border[:border_i] = val
      end
      def border_y
        @border[:border_y]
      end

      #attr_reader :border_x, :border_y, :border_i
      attr_accessor :border
      
      attr_accessor :border_top
      attr_accessor :border_bottom

      attr_accessor :padding_left
      attr_accessor :padding_right

      attr_accessor :margin_left

      attr_accessor :width
      attr_accessor :alignment

      attr_accessor :all_separators

      
      def initialize options = {}
        apply self.class.defaults.merge(options)
      end

      def apply options
        
        options.each do |m, v|
          #p "applying #{m.inspect} #{v}"
          __send__ "#{m}=", v
        end
      end

      # Get vertical border elements from Border instance
      def vertical
        @border.vertical
      end
      
      # Get horizontal border elements from Border instance
      def horizontal(args)
        @border.horizontal(args)
      end

      def remove_verticals
        @border.remove_verticals
      end
      def remove_horizontals
        @border.remove_horizontals
      end
      
      class << self
        def defaults
          klass_defaults = @@defaults.dup
          # border is an object that needs to be duplicated on instantiation,
          # otherwise everything will be referencing the same object-id.
          klass_defaults[:border] = klass_defaults[:border].dup
          return klass_defaults
        end
        
        def defaults= options
          @@defaults = defaults.merge(options)
        end

      end

      def on_change attr
        method_name = :"#{attr}="
        old_method = method method_name
        define_singleton_method(method_name) do |value|
          old_method.call value
          yield attr.to_sym, value
        end
      end

          
    end
  end
end
