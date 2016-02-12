module GemSearch
  require 'mem'
  require 'slop'

  class LibraryNotFound < StandardError; end

  require 'gem_search/command_builder'
  require 'gem_search/commands'
  require 'gem_search/executor'
  require 'gem_search/version'
end
