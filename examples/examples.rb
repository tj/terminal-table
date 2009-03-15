
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'terminal-table/import'

puts
puts table(['a', 'b'], [1, 2], [3, 4])

puts
t = table ['a', 'b']
t << [1, 2]
t << [3, 4]
puts t

puts
user_table = table do |t|
  t.headings = 'First Name', 'Last Name', 'Email'
  t << %w( TJ Holowaychuk tj@vision-media.ca )
  t << %w( Bob Someone bob@vision-media.ca )
  t << %w( Joe Whatever bob@vision-media.ca )
end
puts user_table

puts
user_table = table do
  self.headings = 'First Name', 'Last Name', 'Email'
  add_row ['TJ',  'Holowaychuk', ['tj@vision-media.ca', :right]]
  add_row ['Bob', 'Someone',     'bob@vision-media.ca']
  add_row ['Joe', 'Whatever',    'joe@vision-media.ca']
  align_column 1, :center
end
puts user_table

rows = []
rows << ['Lines',      100]
rows << ['Comments',   20]
rows << ['Ruby',       70]
rows << ['JavaScript', 30]
puts table([nil, 'Lines'], *rows)

rows = []
rows << ['Lines',      100]
rows << ['Comments',   20]
rows << ['Ruby',       70]
rows << ['JavaScript', 30]
puts table(nil, *rows)


Terminal::Table::X = '='
Terminal::Table::Y = '!'
Terminal::Table::I = '*'

rows = []
rows << [nil,  nil, nil]
rows << [nil, ':)', nil]
rows << [nil,  nil, nil]
puts table(nil, *rows)

