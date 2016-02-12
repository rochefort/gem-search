module GemSearch
  module Commands
    class Version < Base
      def call
        puts "gem-search #{GemSearch::VERSION}"
      end
    end
  end
end
