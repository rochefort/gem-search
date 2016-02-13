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
        abort
      end
    end
  end
end
