
require File.expand_path(File.dirname(__FILE__) + "/../lib/terminal-table")

class String
  def deindent
    gsub /^ */, ''
  end
end
