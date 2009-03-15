# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{terminal-table}
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["TJ Holowaychuk"]
  s.date = %q{2009-03-14}
  s.description = %q{Simple,}
  s.email = %q{tj@vision-media.ca}
  s.extra_rdoc_files = ["lib/terminal-table/cell.rb", "lib/terminal-table/core_ext.rb", "lib/terminal-table/heading.rb", "lib/terminal-table/import.rb", "lib/terminal-table/table.rb", "lib/terminal-table/version.rb", "lib/terminal-table.rb", "README.rdoc", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake"]
  s.files = ["examples/examples.rb", "History.rdoc", "lib/terminal-table/cell.rb", "lib/terminal-table/core_ext.rb", "lib/terminal-table/heading.rb", "lib/terminal-table/import.rb", "lib/terminal-table/table.rb", "lib/terminal-table/version.rb", "lib/terminal-table.rb", "Manifest", "Rakefile", "README.rdoc", "spec/cell_spec.rb", "spec/core_ext_spec.rb", "spec/import_spec.rb", "spec/spec_helper.rb", "spec/table_spec.rb", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake", "terminal-table.gemspec", "Todo.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/visionmedia/terminal-table}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Terminal-table", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{terminal-table}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple,}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
