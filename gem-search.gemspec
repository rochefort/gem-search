require File.expand_path("../lib/gem_search/version", __FILE__)

def install_message
  s = ""
  s << "\xf0\x9f\x8d\xba  "
  s << "Thanks for installing!"
end

Gem::Specification.new do |gem|
  gem.authors       = ["rochefort"]
  gem.email         = ["terasawan@gmail.com"]
  gem.homepage      = "https://github.com/rochefort/gem-search"
  gem.summary       = "search gems with using rubygems.org API"
  gem.description   = gem.summary

  gem.files         = `git ls-files -z`.split("\x0")
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gem-search"
  gem.require_paths = ["lib"]
  gem.version       = GemSearch::VERSION

  gem.post_install_message = install_message

  gem.add_dependency "slop", ">=4.4.1", "<4.10.0"
  gem.add_dependency "mem",  "~>0.1.5"

  gem.add_development_dependency "webmock",     "~>3.18.1"
  gem.add_development_dependency "rake",        "~>13.0.0"
  gem.add_development_dependency "rspec",       "~>3.12.0"
  gem.add_development_dependency "simplecov",   "~>0.22.0"
end
