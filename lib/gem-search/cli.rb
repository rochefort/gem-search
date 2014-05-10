require 'json'
require 'open-uri'

module Gem::Search
  class CLI
    include Gem::Search::Rendering
    BASE_URL   = 'https://rubygems.org'
    SEARCH_URL = "#{BASE_URL}/api/v1/search.json?query="

    def search(query, opt_sort='name')
      return unless query

      opt_sort ||= 'name'
      url = "#{SEARCH_URL}#{query}"

      begin
        open_uri(url) do |f|
          gems = JSON.parse(f.read)
          if gems.size.zero?
            puts 'We did not find results.'
            return
          end
          gems_sort!(gems, opt_sort)
          CLI.render(gems)
        end
      rescue => e
        puts 'An unexpected Network error has occurred.'
        puts e
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
