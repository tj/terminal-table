
require 'terminal-table'

module Kernel
  
  ##
  # Generates a Terminal::Table object.
  #
  # === Examples:
  #    
  #    puts table(['a', 'b'], [1, 2], [3, 4])
  #    
  #    # OR
  #
  #    t = table ['a', 'b']
  #    t << [1, 2]
  #    t << [3, 4]
  #    puts t
  #    
  #    # OR
  #
  #    user_table = table do |t|
  #      t.headings = 'First Name', 'Last Name', 'Email'
  #      t << ['TJ',  'Holowaychuk', 'tj@vision-media.ca']
  #      t << ['Bob', 'Someone',     'bob@vision-media.ca']
  #      t << ['Joe', 'Whatever',    'joe@vision-media.ca']
  #    end
  #    puts user_table
  #    
  #    # OR
  #
  #    user_table = table do
  #      self.headings = 'First Name', 'Last Name', 'Email'
  #      add_row ['TJ',  'Holowaychuk', 'tj@vision-media.ca']
  #      add_row ['Bob', 'Someone',     'bob@vision-media.ca']
  #      add_row ['Joe', 'Whatever',    'joe@vision-media.ca']
  #    end
  #    puts user_table
  #
  #   # OR
  #
  #   rows = []
  #   rows << ['Lines',      100]
  #   rows << ['Comments',   20]
  #   rows << ['Ruby',       70]
  #   rows << ['JavaScript', 30]
  #   puts table(nil, *rows)
  #
  
  def table headings = [], *rows, &block
    Terminal::Table.new :headings => headings.to_a, :rows => rows, &block
  end
end