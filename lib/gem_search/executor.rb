require 'json'
require 'open-uri'

module Gem::Search
  class Executor
    include Rendering
    BASE_URL   = 'https://rubygems.org'
    SEARCH_API = "#{BASE_URL}/api/v1/search.json?query=%s&page=%d"
    GEM_API    = "#{BASE_URL}/api/v1/gems/%s.json"
    GEM_URL    = "#{BASE_URL}/gems/%s"

    MAX_REQUEST_COUNT = 20
    MAX_GEMS_PER_PAGE = 30 # It has been determined by Github API

    def search(query, opts)
      return unless query
      print 'Searching '
      gems = []
      (1..MAX_REQUEST_COUNT).each do |n|
        print '.'
        url = SEARCH_API % [query, n]
        gems_by_page = open_rubygems_api(url)
        gems += gems_by_page
        break if gems_by_page.size < MAX_GEMS_PER_PAGE || gems_by_page.size.zero?
      end
      puts

      fail Gem::Search::LibraryNotFound, 'We did not find results.' if gems.size.zero?
      gems_sort!(gems, opts[:sort])
      Executor.render(gems, opts[:detail])
    end

    def browse(gem)
      return unless gem
      api_url = GEM_API % gem
      result = open_rubygems_api(api_url)
      url = result['homepage_uri']
      if url.nil? || url.empty?
        url = GEM_URL % gem
      end
      puts "Opening #{url}"
      browser_open(url)
    end

    private

    # https://github.com/github/hub/blob/9c589396ae38f7b9f98319065ad491149954c152/lib/hub/context.rb#L517
    def browser_open(url)
      cmd = osx? ? 'open' : %w[xdg-open cygstart x-www-browser firefox opera mozilla netscape].find { |comm| which comm }
      system(cmd, url)
    end

    # refer to: https://github.com/github/hub/blob/9c589396ae38f7b9f98319065ad491149954c152/lib/hub/context.rb#L527
    def osx?
      require 'rbconfig'
      RbConfig::CONFIG['host_os'].to_s.include?('darwin')
    end

    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = "#{path}/#{cmd}#{ext}"
          return exe if File.executable? exe
        end
      end
      nil
    end

    def open_rubygems_api(url)
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
