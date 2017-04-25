require "gem_search/rendering"
module GemSearch
  module Commands
    class Run < Base
      include Mem
      include Rendering

      ENABLE_SORT_OPTS = {
        "a" => "downloads",
        "n" => "name",
        "v" => "version_downloads"
      }

      def call
        puts_abort(options) unless valid?(options.arguments)
        gems = search_gems
        puts_abort("We did not find results.") if gems.size.zero?
        gems_sort!(gems)
        render(gems, !options["no-homepage"])
      rescue => e
        unexpected_error(e)
      end

      private

        def valid?(arguments)
          arguments.size > 0 && arguments.none? { |arg| arg.match(/\A-/) }
        end

        def search_gems
          print "Searching "
          gems = Request.new.search(options.arguments[0], options["exact"]) { print "." }
          puts
          gems
        end

        def gems_sort!(gems)
          if sort_opt == "name"
            gems.sort! { |x, y| x[sort_opt] <=> y[sort_opt] }
          else
            gems.sort! { |x, y| y[sort_opt] <=> x[sort_opt] }
          end
        end

        def sort_opt
          sort_opt = options["sort"] ? ENABLE_SORT_OPTS[options["sort"][0].downcase] : nil
          sort_opt = "downloads" unless sort_opt
          sort_opt
        end
        memoize :sort_opt
    end
  end
end
