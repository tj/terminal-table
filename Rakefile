
require 'rubygems'
require 'rake'
require 'echoe'
require './lib/terminal-table.rb'

Echoe.new("terminal-table", Terminal::Table::VERSION) do |p|
  p.author = "TJ Holowaychuk"
  p.email = "tj@vision-media.ca"
  p.summary = "Simple, feature rich ascii table generation library"
  p.url = "http://github.com/visionmedia/terminal-table"
  p.runtime_dependencies = []
end

Dir['tasks/**/*.rake'].sort.each { |lib| load lib }