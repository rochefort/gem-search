module Gem
  module Search
    class LibraryNotFound    < StandardError; end
    autoload :Command ,  'gem_search/command'
    autoload :Executor , 'gem_search/executor'
    autoload :Rendering, 'gem_search/rendering'
    autoload :VERSION  , 'gem_search/version'
  end
end
