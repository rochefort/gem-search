require 'json'
require 'open-uri'

module Gem::Search
  class CLI
    BASE_URL   = 'https://rubygems.org'
    SEARCH_URL = "#{BASE_URL}/api/v1/search.json?query="
    DEFAULT_RULED_LINE_SIZE = [50, 8, 9]

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
          fmt_size = ruled_line_size(gems)
          gems_sort!(gems, opt_sort)
          render_header(fmt_size)
          render_body(gems, fmt_size)
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
        if proxy
          if proxy.user && proxy.password
            option[:proxy_http_basic_authentication] = [proxy, proxy.user, proxy.password]
          end
        end
        open(url, option, &block)
      end

      def ruled_line_size(gems)
        line_size = DEFAULT_RULED_LINE_SIZE.dup
        max_name_size = gems.map { |gem| "#{gem['name']} (#{gem['version']})".size }.max
        line_size[0] =  max_name_size if max_name_size > line_size[0]
        line_size
      end

      def gems_sort!(gems, opt_sort)
        if opt_sort == 'name'
          gems.sort!{ |x,y| x[opt_sort] <=> y[opt_sort] }
        else
          gems.sort!{ |x,y| y[opt_sort] <=> x[opt_sort] }
        end
      end

      def render_header(f)
        fmt = "%-#{f[0]}s %#{f[1]}s %#{f[2]}s"
        puts fmt % ['NAME', 'DL(ver)', 'DL(all)']
        puts fmt % ['-'*f[0], '-'*f[1], '-'*f[2]]
      end

      def render_body(gems, f)
        fmt = "%-#{f[0]}s %#{f[1]}d %#{f[2]}d"
        gems.each do |gem|
          puts fmt % [
            "#{gem['name']} (#{gem['version']})",
            gem['version_downloads'],
            gem['downloads']
          ]
        end
      end

  end
end
