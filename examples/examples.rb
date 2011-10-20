$:.unshift File.dirname(__FILE__) + '/../lib'
require 'terminal-table/import'



rows = []
rows << ['One', 1]
rows << ['Two', 2]
rows << ['Three', 3]
puts Terminal::Table.new :rows => rows


puts Terminal::Table.new :headings => ['Word', 'Number'], :rows => rows

t = Terminal::Table.new :headings => ['Word', 'Number'], :rows => rows
t.align_column 1, :right
t << ["Four", {:value => 4.0, :alignment => :center}]

puts t

table = Terminal::Table.new :title => "Cheatsheet", :headings => ['Word', 'Number'], :rows => rows

puts table

table.style = {:width => 40, :padding_left => 3, :border_x => "=", :border_i => "x"}
puts table

table = Terminal::Table.new do |t|
  t << ['One', 1]
  t << :separator
  t.add_row ["Two\nDouble", 2]
  t.add_separator
  t.add_row ['Three', 3]
end
puts table

exit

puts
puts table(['a', 'b'], [1, 2], [3, 4])

puts
t = table ['a', 'b']
t.style = {:padding_left => 2, :width => 80}
t << [1, 2]
t << [3, 4]
t << :separator
t << [4, 6]
puts t

puts
user_table = table do |v|
  v.title = "Contact Information"
  v.headings = 'First Name', 'Last Name', 'Email'
  v << %w( TJ Holowaychuk tj@vision-media.ca )
  v << %w( Bob Someone bob@vision-media.ca )
  v << %w( Joe Whatever bob@vision-media.ca )
end
puts user_table

puts
user_table = table do |v|
  v.style.width = 80
  v.headings = 'First Name', 'Last Name', 'Email'
  v << %w( TJ Holowaychuk tj@vision-media.ca )
  v << %w( Bob Someone bob@vision-media.ca )
  v << %w( Joe Whatever bob@vision-media.ca )
end
puts user_table

puts
user_table = table do
  self.headings = 'First Name', 'Last Name', 'Email'
  add_row ['TJ',  'Holowaychuk', 'tj@vision-media.ca']
  add_row ['Bob', 'Someone',     'bob@vision-media.ca']
  add_row ['Joe', 'Whatever',    'joe@vision-media.ca']
  add_separator
  add_row ['Total', { :value => '3', :colspan => 2, :alignment => :right }]
  align_column 1, :center
end
puts user_table

puts
user_table = table do
  self.headings = ['First Name', 'Last Name', {:value => 'Phones', :colspan => 2, :alignment => :center}]
  add_row ['Bob', 'Someone',     '123', '456']
  add_row :separator
  add_row ['TJ',  'Holowaychuk', {:value => "No phones\navaiable", :colspan => 2, :alignment => :center}]
  add_row :separator
  add_row ['Joe', 'Whatever',    '4324', '343242']
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

rows = []
rows << ['Lines',      100]
rows << ['Comments',   20]
rows << ['Ruby',       70]
rows << ['JavaScript', 30]
table = table([{ :value => 'Stats', :colspan => 2, :alignment => :center }], *rows)
table.align_column 1, :right
puts table
