
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'terminal-table/import'

puts
puts table(['a', 'b'], [[1, 2], [3, 4]])

puts
t = table ['a', 'b']
t << [1, 2]
t << [3, 4]
puts t

puts
user_table = table do |t|
  t.headings = 'First Name', 'Last Name', 'Email'
  t << ['TJ',  'Holowaychuk', 'tj@vision-media.ca']
  t << ['Bob', 'Someone',     'bob@vision-media.ca']
  t << ['Joe', 'Whatever',    'joe@vision-media.ca']
end

puts user_table

puts
user_table = table do
  self.headings = 'First Name', 'Last Name', 'Email'
  add_row ['TJ',  'Holowaychuk', 'tj@vision-media.ca']
  add_row ['Bob', 'Someone',     'bob@vision-media.ca']
  add_row ['Joe', 'Whatever',    'joe@vision-media.ca']
end

puts user_table