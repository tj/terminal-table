
require 'terminal-table'

class String
  def deindent
    gsub /^ */, ''
  end
end
