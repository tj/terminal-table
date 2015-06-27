require 'terminal-table'
require 'term/ansicolor'

class String
  include Term::ANSIColor

  def deindent
    strip.gsub(/^ */, '')
  end
end

RSpec.configure do |c|
  c.expect_with(:rspec) { |c| c.syntax = :should }
end
