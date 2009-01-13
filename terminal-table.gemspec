# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{terminal-table}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["TJ Holowaychuk"]
  s.date = %q{2009-01-13}
  s.description = %q{Simple,}
  s.email = %q{tj@vision-media.ca}
  s.extra_rdoc_files = ["README.rdoc", "lib/terminal-table.rb", "lib/terminal-table/core_ext.rb", "lib/terminal-table/cell.rb", "lib/terminal-table/heading.rb", "lib/terminal-table/table.rb", "lib/terminal-table/version.rb", "lib/terminal-table/import.rb", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake"]
  s.files = ["History.rdoc", "Rakefile", "README.rdoc", "lib/terminal-table.rb", "lib/terminal-table/core_ext.rb", "lib/terminal-table/cell.rb", "lib/terminal-table/heading.rb", "lib/terminal-table/table.rb", "lib/terminal-table/version.rb", "lib/terminal-table/import.rb", "spec/spec_helper.rb", "spec/core_ext_spec.rb", "spec/table_spec.rb", "spec/cell_spec.rb", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake", "Todo.rdoc", "Manifest", "terminal-table.gemspec"]
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
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
