require "json"
require "open-uri"

module GemSearch
  class Request
    SEARCH_API = "#{RUBYGEMS_URL}/api/v1/search.json?query=%s&page=%d"
    GEM_API    = "#{RUBYGEMS_URL}/api/v1/gems/%s.json"

    MAX_REQUEST_COUNT = 20
    MAX_GEMS_PER_PAGE = 30 # It has been determined by Rubygems API

    def search(query, &post_hook)
      gems = []
      (1..MAX_REQUEST_COUNT).each do |n|
        post_hook.call if post_hook
        url = SEARCH_API % [query, n]
        results = request_ruby_gems_api(url)
        gems += results
        break if search_ended?(results.size)
      end
      gems
    rescue Interrupt
      gems
    end

    def search_for_browse(gem)
      api_url = GEM_API % gem
      request_ruby_gems_api(api_url)
    end

    private

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
  end
end
