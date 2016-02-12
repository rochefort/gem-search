module GemSearch
  module Commands
    class Help < Base
      def call
        puts @options
      end
    end
  end
end
