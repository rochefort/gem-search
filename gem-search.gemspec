require File.expand_path('../lib/gem_search/version', __FILE__)

def install_message
  s = ''
  s << "\xf0\x9f\x8d\xba  " if or_over_mac_os_lion?
  s << 'Thanks for installing!'
end

def or_over_mac_os_lion?
  return false unless RUBY_PLATFORM =~ /darwin/

  macos_full_version = `/usr/bin/sw_vers -productVersion`.chomp
  macos_version = macos_full_version[/10\.\d+/]
  macos_version >= '10.7'  # 10.7 is lion
end

Gem::Specification.new do |gem|
  gem.authors       = ['rochefort']
  gem.email         = ['terasawan@gmail.com']
  gem.homepage      = 'https://github.com/rochefort/gem-search'
  gem.summary       = 'search gems with using rubygems.org API'
  gem.description   = gem.summary

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'gem-search'
  gem.require_paths = ['lib']
  gem.version       = Gem::Search::VERSION

  gem.post_install_message = install_message

  gem.add_dependency 'slop', '~>4.0.0'
  gem.add_dependency 'json', '~>1.8.1'
  gem.add_dependency 'mem'

  # gem.add_development_dependency 'pry',     '~>0.9.12.6'
  gem.add_development_dependency 'webmock', '~>1.18.0'
  gem.add_development_dependency 'rake',    '~>10.3.1'

  gem.add_development_dependency 'rspec',       '~> 3.0.0'
  gem.add_development_dependency 'simplecov',   '~> 0.9.0'
end
