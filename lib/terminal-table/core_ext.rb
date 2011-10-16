
class String
  def align position, length
    send position, length
  end
  alias_method :left, :ljust
  alias_method :right, :rjust
end

module Enumerable
  def map_with_index &block
    vals = []
    each_with_index { |v, i| vals << yield(v, i) } 
    vals
  end
  alias :collect_with_index :map_with_index
end

class Object
  def yield_or_eval &block
    return unless block
    if block.arity > 0
      yield self
    else
      self.instance_eval &block
    end
  end
end