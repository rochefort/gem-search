require 'json'
require 'open-uri'
require 'gem_search/rendering'
require 'gem_search/utils/system_util'

module GemSearch
  class Executor
    include Rendering
    include Utils::SystemUtil
    BASE_URL   = 'https://rubygems.org'
    SEARCH_API = "#{BASE_URL}/api/v1/search.json?query=%s&page=%d"
    GEM_API    = "#{BASE_URL}/api/v1/gems/%s.json"
    GEM_URL    = "#{BASE_URL}/gems/%s"

    MAX_REQUEST_COUNT = 20
    MAX_GEMS_PER_PAGE = 30 # It has been determined by Github API

    def search(query, opts)
      return unless query
      print 'Searching '
      gems = search_gems(query)
      puts
      fail GemSearch::LibraryNotFound, 'We did not find results.' if gems.size.zero?
      gems_sort!(gems, opts[:sort])
      Executor.render(gems, opts[:detail])
    end

    def browse(gem)
      return unless gem
      api_url = GEM_API % gem
      result = request_ruby_gems_api(api_url)
      url = result['homepage_uri']
      if url.nil? || url.empty?
        url = GEM_URL % gem
      end
      puts "Opening #{url}"
      browser_open(url)
    end

    private

    def search_gems(query)
      gems = []
      (1..MAX_REQUEST_COUNT).each do |n|
        print '.'
        url = SEARCH_API % [query, n]
        results = request_ruby_gems_api(url)
        gems += results
        break if search_ended?(results.size)
      end
      gems
    end

    def search_ended?(size)
      size < MAX_GEMS_PER_PAGE || size.zero?
    end

    def request_ruby_gems_api(url)
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
