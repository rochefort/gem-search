module Gem::Search
  module Commands
    class Version < Base
      def call
        puts "gem-search #{Gem::Search::VERSION}"
      end
    end
  end
end
