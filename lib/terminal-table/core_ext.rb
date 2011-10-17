
class String
  def align position, length
    self.__send__ position, length
  end
  alias_method :left, :ljust
  alias_method :right, :rjust
end