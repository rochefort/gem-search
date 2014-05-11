require File.expand_path('../lib/gem-search/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["rochefort"]
  gem.email         = ["terasawan@gmail.com"]
  gem.homepage      = "https://github.com/rochefort/gem-search"
  gem.summary       = "search gems with using rubygems.org API"
  gem.description   = gem.summary

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gem-search"
  gem.require_paths = ["lib"]
  gem.version       = Gem::Search::VERSION

  gem.add_dependency 'slop', '~>3.5.0'
  gem.add_dependency 'json', '~>1.8.1'

  gem.add_development_dependency 'webmock', '~>1.17.4'
  gem.add_development_dependency 'rake',    '~>10.3.1'

  gem.add_development_dependency 'rspec',       '~> 2.14.1'
  gem.add_development_dependency 'simplecov',   '~> 0.8.2'
end
