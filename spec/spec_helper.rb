# -*- encoding: utf-8 -*-
require "rubygems"
require "simplecov"
SimpleCov.start

require "webmock/rspec"
# require 'pry'
require "gem_search"

require "helpers"

RSpec.configure do |config|
  config.include Helpers

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.expose_dsl_globally = false

  config.example_status_persistence_file_path = "spec/examples.txt"
  config.order = :random
  Kernel.srand config.seed
end

def load_http_stubs(file_name)
  open(File.join(File.dirname(__FILE__), "http_stubs", file_name)).read
end

# stubs for search API
def stub_request_search(query, page, body)
  stub_request(:get, build_search_uri(query, page)).to_return(status: 200, body: body)
end

def stub_request_search_no_result_with_page(query, page)
  stub_request(:get, build_search_uri(query, page)).to_return(status: 200, body: "[]")
end

def build_search_uri(query, page)
  Request::SEARCH_API % [query, page]
end

# stubs for gems API
def stub_request_gems(query, body)
  stub_request(:get, build_gems_uri(query)).to_return(status: 200, body: body)
end

def stub_request_gems_no_result(query)
  stub_request(:get, build_gems_uri(query)).to_return(status: 404, body: "[]")
end

def build_gems_uri(query)
  Request::GEM_API % query
end

class String
  def unindent
    gsub(/^\s+\|/, "")
  end
end
