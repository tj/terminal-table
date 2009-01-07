
require 'terminal-table'

class String
  def deindent spaces = 6
    gsub /^ {#{spaces},}/, ''
  end
end