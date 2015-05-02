
class String
  def align position, length
    self.__send__ position, length - cjks.size
  end
  alias_method :left, :ljust
  alias_method :right, :rjust

  def cjks
    self.scan /\p{Han}|\p{Katakana}|\p{Hiragana}\p{Hangul}/
  end

  def width
    size + cjks.size
  end

end
