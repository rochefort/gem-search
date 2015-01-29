module Gem::Search
  module Commands
    class Run < Base
      ENABLE_SORT_OPTS = {
        'v' => 'version_downloads',
        'a' => 'downloads',
        'n' => 'name',
      }

      def call
        unless valid?(options.arguments)
          puts options
          abort
        end

        executor = Executor.new
        gem = options.arguments[0]
        executor.search(gem, setup_opts)
      rescue Gem::Search::LibraryNotFound => e
        puts e.message
        abort
      rescue => e
        puts "An unexpected #{e.class} has occurred."
        puts e.message
        puts e.backtrace if ENV['DEBUG']
        abort
      end

      private

      def setup_opts
        {
          sort: ENABLE_SORT_OPTS[options['sort']] || 'downloads',
          detail: options.detail?
        }
      end

      def valid?(arguments)
        arguments.size > 0 && arguments.none? { |arg| arg.match(/\A-/) }
      end
    end
  end
end
