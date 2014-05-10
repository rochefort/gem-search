require 'slop'

class Slop
  def opt_description(msgs)
    ind = ' ' * 22
    msgs.inject { |rtn, msg| rtn << "\n#{ind}#{msg}" }
  end
end

module Gem::Search
  class Command
    ENABLE_SORT_OPT = {
      'v' => 'version_downloads',
      'a' => 'downloads',
    }

    OPTS = Slop.parse(help: true) do
      banner "Usage: gem-search gem_name [options]\n"
      on :s, :sort, opt_description([
          'Sort by the item.',
          '  [n]ame :default  eg. gem-search webkit',
          '  [v]er  :DL(ver)  eg. gem-search webkit -s v',
          '  [a]ll  :DL(all)  eg. gem-search webkit -s a'
        ]), :argument => :optional
      on :v, :version, 'Display the version.'
    end

    def run
      version if OPTS['v']
      validate

      gs = Executor.new
      gs.search(ARGV[0], ENABLE_SORT_OPT[OPTS['sort']])
    end

    private
      def version
        puts "gem-search #{Gem::Search::VERSION}"
        exit
      end

      def validate
        if (ARGV.size == 0)
          puts OPTS
          abort
        end

        if ARGV.any? { |arg| arg.match(/\A-/) }
          puts OPTS
          exit
        end
      end
  end
end