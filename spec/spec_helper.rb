# -*- encoding: utf-8 -*-
require 'rubygems'
require 'simplecov'
SimpleCov.start

require 'webmock/rspec'
require 'gem-search'

# http://d.hatena.ne.jp/POCHI_BLACK/20100324
# this method is written by wycats
def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end

def load_http_stubs(file_name)
  open(File.join(File.dirname(__FILE__), 'http_stubs', file_name)).read
end

def stub_request_search(page, body)
  stub_request(:get, build_search_uri(query, page)).to_return(:status => 200, :body => body)
end

def stub_request_no_result_with_page(page)
  stub_request(:get, build_search_uri(query, page)).to_return(:status => 200, :body => '[]')
end

def build_search_uri(query, page)
  Executor::SEARCH_URL % [query, page]
end

def dummy_search_result
  # top 3 gems searching with 'factory_girl'
  # https://rubygems.org/api/v1/search.json?query=factory_girl
  [{"name"=>"factory_girl",
    "downloads"=>2042859,
    "version"=>"3.6.0",
    "version_downloads"=>541,
    "platform"=>"ruby",
    "authors"=>"Josh Clayton, Joe Ferris",
    "info"=>
     "factory_girl provides a framework and DSL for defining and\n                      using factories - less error-prone, more explicit, and\n                      all-around easier to work with than fixtures.",
    "project_uri"=>"http://rubygems.org/gems/factory_girl",
    "gem_uri"=>"http://rubygems.org/gems/factory_girl-3.6.0.gem",
    "homepage_uri"=>"https://github.com/thoughtbot/factory_girl",
    "wiki_uri"=>"",
    "documentation_uri"=>"",
    "mailing_list_uri"=>"",
    "source_code_uri"=>"https://github.com/thoughtbot/factory_girl",
    "bug_tracker_uri"=>"",
    "dependencies"=>
     {"development"=>
       [{"name"=>"appraisal", "requirements"=>"~> 0.4"},
        {"name"=>"aruba", "requirements"=>">= 0"},
        {"name"=>"bourne", "requirements"=>">= 0"},
        {"name"=>"cucumber", "requirements"=>"~> 1.1"},
        {"name"=>"mocha", "requirements"=>">= 0"},
        {"name"=>"rspec", "requirements"=>"~> 2.0"},
        {"name"=>"simplecov", "requirements"=>">= 0"},
        {"name"=>"sqlite3-ruby", "requirements"=>">= 0"},
        {"name"=>"timecop", "requirements"=>">= 0"},
        {"name"=>"yard", "requirements"=>">= 0"}],
      "runtime"=>[{"name"=>"activesupport", "requirements"=>">= 3.0.0"}]}},
   {"name"=>"factory_girl_rails",
    "downloads"=>1238780,
    "version"=>"3.5.0",
    "version_downloads"=>39724,
    "platform"=>"ruby",
    "authors"=>"Joe Ferris",
    "info"=>
     "factory_girl_rails provides integration between\n    factory_girl and rails 3 (currently just automatic factory definition\n    loading)",
    "project_uri"=>"http://rubygems.org/gems/factory_girl_rails",
    "gem_uri"=>"http://rubygems.org/gems/factory_girl_rails-3.5.0.gem",
    "homepage_uri"=>"http://github.com/thoughtbot/factory_girl_rails",
    "wiki_uri"=>nil,
    "documentation_uri"=>nil,
    "mailing_list_uri"=>nil,
    "source_code_uri"=>nil,
    "bug_tracker_uri"=>nil,
    "dependencies"=>
     {"development"=>
       [{"name"=>"aruba", "requirements"=>">= 0"},
        {"name"=>"cucumber", "requirements"=>"~> 1.0.0"},
        {"name"=>"rails", "requirements"=>"= 3.0.7"},
        {"name"=>"rake", "requirements"=>">= 0"},
        {"name"=>"rspec", "requirements"=>"~> 2.6.0"}],
      "runtime"=>
       [{"name"=>"factory_girl", "requirements"=>"~> 3.5.0"},
        {"name"=>"railties", "requirements"=>">= 3.0.0"}]}},
   {"name"=>"factory_girl_generator",
    "downloads"=>15547,
    "version"=>"0.0.3",
    "version_downloads"=>8015,
    "platform"=>"ruby",
    "authors"=>"Les Hill",
    "info"=>"Rails 3 generator for factory_girl",
    "project_uri"=>"http://rubygems.org/gems/factory_girl_generator",
    "gem_uri"=>"http://rubygems.org/gems/factory_girl_generator-0.0.3.gem",
    "homepage_uri"=>"http://github.com/leshill/factory_girl_generator",
    "wiki_uri"=>nil,
    "documentation_uri"=>nil,
    "mailing_list_uri"=>nil,
    "source_code_uri"=>nil,
    "bug_tracker_uri"=>nil,
    "dependencies"=>{"development"=>[], "runtime"=>[]}}
  ].to_json
end

class String
  def unindent
    gsub(/^\s+\|/, '')
  end
end
