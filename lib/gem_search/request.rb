require "json"
require "open-uri"

module GemSearch
  class Request
    SEARCH_API = "#{RUBYGEMS_URL}/api/v1/search.json?query=%s&page=%d"
    GEM_API    = "#{RUBYGEMS_URL}/api/v1/gems/%s.json"

    MAX_REQUEST_COUNT = 20

    def search(query, use_exact_match = false, &post_hook)
      gems = []
      (1..MAX_REQUEST_COUNT).each do |n|
        post_hook.call if post_hook
        url = SEARCH_API % [query, n]
        results = request_ruby_gems_api(url)
        if use_exact_match
          matched_result = extract_exact_match(query, results)
          if matched_result
            gems << matched_result
            break
          end
        else
          gems += results
        end
        break if results.size.zero?
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
        JSON.parse(URI.open(url, option).read)
      end

      def extract_exact_match(keyword, results)
        results.find { |result| result["name"] == keyword }
      end
  end
end
