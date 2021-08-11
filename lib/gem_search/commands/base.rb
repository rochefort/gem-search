module GemSearch
  module Commands
    class Base
      attr_reader :options

      def initialize(options)
        @options = options
      end

      private

        def puts_abort(args)
          puts args
          exit 1
        end

        def unexpected_error(e)
          puts "\nAn unexpected #{e.class} has occurred."
          puts e.message
          puts e.backtrace if ENV["DEBUG"]
          exit 1
        end
    end
  end
end
