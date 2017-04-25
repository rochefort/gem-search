require "mem"
require "slop"

module GemSearch
  class CommandBuilder
    include Mem

    attr_reader :arguments

    def initialize(arguments = ARGV)
      @arguments = arguments
    end

    def build
      command_class.new(options)
    end

    private

      def command_class
        case
        when options[:help] then    Commands::Help
        when options[:version] then Commands::Version
        when options[:browse] then  Commands::Browse
        else Commands::Run
        end
      end

      def options
        Slop.parse(arguments, suppress_errors: true) do |opts|
          opts.banner = "Usage: gem-search gem_name [options]\n"
          sort_msg = detail_message([
            "Sort by the field.",
            "default [a]ll",
            "[a]ll  :DL(all)  e.g.: gem-search webkit -s a",
            "[v]er  :DL(ver)  e.g.: gem-search webkit -s v",
            "[n]ame :         e.g.: gem-search webkit -s n"
          ])
          opts.bool("-e", "--exact", "Use the exact match")
          opts.string("-s", "--sort", sort_msg)
          opts.string("-b", "--browse", "Open rubygem's homepage in the system's default web browser.")
          opts.on("--no-homepage", "Do not show rubygems's homepage url.")
          opts.on("-v", "--version", "Display the version.")
          opts.on("-h", "--help", "Display this help message.")
        end
      end
      memoize :options

      def detail_message(msgs)
        indent = " " * 21
        main = msgs[0]
        detail = msgs[1..-1].map { |msg| "#{indent}#{msg}" }.join("\n")
        "#{main}\n#{detail}"
      end
  end
end
