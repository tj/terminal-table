require 'terminal-table'

class String
  def deindent
    strip.gsub(/^ */, '')
  end
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
end
