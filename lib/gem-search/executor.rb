require 'json'
require 'open-uri'

module Gem::Search
  class Executor
    include Gem::Search::Rendering
    BASE_URL   = 'https://rubygems.org'
    SEARCH_URL = "#{BASE_URL}/api/v1/search.json?query="

    def search(query, opt_sort='name')
      return unless query

      url = "#{SEARCH_URL}#{query}"
      open_uri(url) do |f|
        gems = JSON.parse(f.read)
        raise Gem::Search::LibraryNotFound, 'We did not find results.' if gems.size.zero?

        gems_sort!(gems, opt_sort)
        Executor.render(gems)
      end
    end

    private
      def open_uri(url, &block)
        option = {}
        proxy = URI.parse(url).find_proxy
        if proxy && proxy.user && proxy.password
          option[:proxy_http_basic_authentication] = [proxy, proxy.user, proxy.password]
        end
        open(url, option, &block)
      end

      def gems_sort!(gems, opt_sort)
        if opt_sort == 'name'
          gems.sort!{ |x,y| x[opt_sort] <=> y[opt_sort] }
        else
          gems.sort!{ |x,y| y[opt_sort] <=> x[opt_sort] }
        end
      end

  end
end
