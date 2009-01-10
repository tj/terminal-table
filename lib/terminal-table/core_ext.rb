
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
    each_with_index do |v, i|
      result << yield(v, i)
    end
    result
  end
  alias :collect_with_index :map_with_index
end