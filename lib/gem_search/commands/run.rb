module GemSearch
  module Commands
    class Run < Base
      ENABLE_SORT_OPTS = {
        'a' => 'downloads',
        'n' => 'name',
        'v' => 'version_downloads',
      }

      def call
        unless valid?(options.arguments)
          puts options
          abort
        end
        executor = Executor.new
        gem = options.arguments[0]
        executor.search(gem, setup_opts)
      rescue GemSearch::LibraryNotFound => e
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
        sort = options['sort'] ? ENABLE_SORT_OPTS[options['sort'][0].downcase] : nil
        {
          sort: sort || 'downloads',
          has_homepage: !options['no-homepage']
        }
      end

      def valid?(arguments)
        arguments.size > 0 && arguments.none? { |arg| arg.match(/\A-/) }
      end
    end
  end
end
