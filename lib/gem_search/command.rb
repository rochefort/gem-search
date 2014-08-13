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
      'n' => 'name',
    }

    OPTS = Slop.parse(help: true) do
      banner "Usage: gem-search gem_name [options]\n"
      on :s, :sort, opt_description([
        'Sort by the item.',
        '  default [a]ll',
        '  [a]ll  :DL(all)  eg. gem-search webkit -s a',
        '  [v]er  :DL(ver)  eg. gem-search webkit -s v',
        '  [n]ame :         eg. gem-search webkit -s n',
      ]), argument: :optional
      on :v, :version, 'Display the version.'

      command 'browse' do
        description "Open rubygem's homepage in the system's default web browser"
        run do |_opts, args|
          gem = args.first
          executor = Executor.new
          begin
            executor.browse(gem)
          rescue OpenURI::HTTPError
            puts 'No such gem.'
            abort
          rescue => e
            puts e.message
            puts e.stacktrace
            abort
          end
          exit
        end
      end
    end

    def run
      version if OPTS['v']
      validate

      gs = Executor.new
      if ENABLE_SORT_OPT[OPTS['sort']]
        gs.search(ARGV[0], ENABLE_SORT_OPT[OPTS['sort']])
      else
        gs.search(ARGV[0])
      end
    rescue LibraryNotFound => e
      puts e.message
      abort
    rescue => e
      puts "An unexpected #{e.class} has occurred."
      puts e.message
      abort
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
