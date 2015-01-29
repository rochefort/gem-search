module Gem::Search
  require 'mem'
  require 'slop'

  class LibraryNotFound < StandardError; end

  require 'gem_search/command_builder'
  require 'gem_search/commands'
  require 'gem_search/version'
  require 'gem_search/rendering'
  require 'gem_search/executor'
end
