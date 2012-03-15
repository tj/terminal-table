# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{terminal-table}
  s.version = "1.4.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["TJ Holowaychuk", "Scott J. Goldman"]
  s.date = %q{2012-3-15}
  s.description = %q{Simple, feature rich ascii table generation library}
  s.email = %q{tj@vision-media.ca}
  s.extra_rdoc_files = ["README.rdoc", "lib/terminal-table.rb", "lib/terminal-table/cell.rb", "lib/terminal-table/core_ext.rb", "lib/terminal-table/import.rb", "lib/terminal-table/table.rb", "lib/terminal-table/version.rb", "lib/terminal-table/row.rb", "lib/terminal-table/separator.rb", "lib/terminal-table/style.rb", "lib/terminal-table/table_helper.rb", "lib/terminal-table/version.rb", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake"]
  s.files = ["History.rdoc", "Manifest", "README.rdoc", "Rakefile", "Todo.rdoc", "examples/examples.rb", "lib/terminal-table.rb", "lib/terminal-table/cell.rb", "lib/terminal-table/core_ext.rb", "lib/terminal-table/import.rb", "lib/terminal-table/table.rb", "lib/terminal-table/table_helper.rb", "lib/terminal-table/version.rb", "lib/terminal-table/row.rb", "lib/terminal-table/separator.rb", "lib/terminal-table/style.rb", "spec/cell_spec.rb", "spec/core_ext_spec.rb", "spec/import_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/table_spec.rb", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake", "terminal-table.gemspec"]
  s.homepage = %q{http://github.com/visionmedia/terminal-table}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Terminal-table", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{terminal-table}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Simple, feature rich ascii table generation library}

  if s.respond_to? :specification_version= then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
