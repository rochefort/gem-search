module Gem::Search
  module Commands
    class Browse < Base
      def call
        executor = Executor.new
        executor.browse(options[:browse])
        rescue OpenURI::HTTPError
          puts 'No such gem.'
          abort
        rescue => e
          puts e.message
          puts e.stacktrace if ENV['DEBUG']
          abort
      end
    end
  end
end
