require 'json'
require 'open-uri'

module Gem::Search
  class Executor
    include Gem::Search::Rendering
    BASE_URL   = 'https://rubygems.org'
    SEARCH_URL = "#{BASE_URL}/api/v1/search.json?query=%s&page=%d"
    MAX_REQUEST_COUNT = 20

    def search(query, opt_sort = 'downloads')
      return unless query
      print 'Searching '
      gems = []
      (1..MAX_REQUEST_COUNT).each do |n|
        print '.'
        url = SEARCH_URL % [query, n]
        gems_by_page = search_rubygems(url)
        break if gems_by_page.size.zero?
        gems += gems_by_page
      end
      puts

      fail Gem::Search::LibraryNotFound, 'We did not find results.' if gems.size.zero?
      gems_sort!(gems, opt_sort)
      Executor.render(gems)
    end

    private

    def search_rubygems(url)
      option = {}
      proxy = URI.parse(url).find_proxy
      if proxy
        if proxy.user && proxy.password
          option[:proxy_http_basic_authentication] = [proxy, proxy.user, proxy.password]
        else
          option[:proxy] = proxy
        end
      end
      JSON.parse(open(url, option).read)
    end

    def gems_sort!(gems, opt_sort)
      if opt_sort == 'name'
        gems.sort! { |x, y| x[opt_sort] <=> y[opt_sort] }
      else
        gems.sort! { |x, y| y[opt_sort] <=> x[opt_sort] }
      end
    end
  end
end
