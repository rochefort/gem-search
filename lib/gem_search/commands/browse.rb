require 'gem_search/utils/system_util'

module GemSearch
  module Commands
    class Browse < Base
      include Utils::SystemUtil

      GEM_URL = "#{RUBYGEMS_URL}/gems/%s"

      def call
        executor = Executor.new
        gem_name = options[:browse]
        result = executor.search_for_browse(gem_name)
        url = extract_uri(result['homepage_uri'], gem_name)
        puts "Opening #{url}"
        browser_open(url)
      rescue OpenURI::HTTPError
        puts_abort('No such a gem.')
      rescue => e
        unexpected_error(e)
      end

      private

      def extract_uri(homepage_uri, gem_name)
        if homepage_uri.nil? || homepage_uri.empty?
          GEM_URL % gem_name
        else
          homepage_uri
        end
      end
    end
  end
end
