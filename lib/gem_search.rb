module GemSearch
  require 'mem'
  require 'slop'

  RUBYGEMS_URL = 'https://rubygems.org'

  require 'gem_search/command_builder'
  require 'gem_search/commands'
  require 'gem_search/executor'
  require 'gem_search/version'
end
