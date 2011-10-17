
require File.dirname(__FILE__) + '/../lib/terminal-table'

class String
  def deindent
    strip.gsub(/^ */, '')
  end
end
