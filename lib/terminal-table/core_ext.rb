
class String
  
  ##
  # Align to +position+, which may be :left, :right, or :center.
  
  def align position, length
    send position, length
  end
  alias_method :left, :ljust
  alias_method :right, :rjust
  
end

module Enumerable
  def map_with_index &block
    result = []
    each_with_index { |v, i| result << yield(v, i) } 
    result
  end
  alias :collect_with_index :map_with_index
end

class Object
  
  ##
  # Yields or instance_eval's a +block+ depending on the arity of a block
  # in order to support both types of block syntax for DSL's.
  
  def yield_or_eval &block
    if block_given?
      if block.arity > 0
        yield self
      else
        self.instance_eval &block
      end
    end
  end
  
end