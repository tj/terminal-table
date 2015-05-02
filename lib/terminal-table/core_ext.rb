
class String
  class String
  CJKC_RANGES = [
    #20941 CJK Unified Ideographs block.
    (0x4E00..0x9FCC),
    #6582 characters from the CJKUI Ext A block
    (0x3400..0x4DB5),
    #full width symbols
    (0xFF01..0xFF5E),
    (0xFFE0..0xFFEE),
    #42711 characters from the CJKUI Ext B block.
    (0x21600..0x2A6DF),
    #4149 characters from the CJKUI Ext C block.
    (0x2A700..0x2B734),
    #222 characters from the CJKUI Ext D block.
    (0x2B740..0x2B81D),
  ]

  CJKC_MIN = 0x3400

  def cjks
    cjk_a = []
    self.each_codepoint.with_index do |cp, i|
      next if cp < CJKC_MIN
      cjk_a << self[i]  if CJKC_RANGES.any? {|range| range.member? cp }
    end
    cjk_a
  end

  def align position, length
    self.__send__ position, length - cjks.size
  end
  alias_method :left, :ljust
  alias_method :right, :rjust

  def width
    size + cjks.size
  end

end
