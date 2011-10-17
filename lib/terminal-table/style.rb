
module Terminal
  class Table
    class Style
      @@defaults = {
        :border_x => "-", :border_y => "|", :border_i => "+",
        :padding_left => 1, :padding_right => 1
      }
      ##
      # Style options.
      
      attr_accessor :border_x
      attr_accessor :border_y
      attr_accessor :border_i
      
      attr_accessor :padding_left
      attr_accessor :padding_right
      
      attr_accessor :width
      
      ##
      # Initialize with _options_.
      
      def initialize options = {}
        apply self.class.defaults.merge(options)
      end
      
      def apply options
        options.each { |m, v| __send__ "#{m}=", v }
      end
      class << self
        def defaults
          @@defaults
        end
        
        def defaults= options
          @@defaults = defaults.merge(options)
        end
      end
    end
  end
end