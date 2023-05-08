require File.expand_path("../lib/onedotzip/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "onedotzip"
  s.version     = Onedotzip::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Dan Q']
  s.email       = ['onedotzip@danq.me']
  s.homepage    = 'http://github.com/Dan-Q/onedotzip'
  s.summary     = '...'
  s.description = "..."

  s.required_rubygems_version = '>= 3.2.3'

  # Dependencies
  s.add_dependency 'rubyzip', '~> 2.3.2'

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["onedotzip"]
end