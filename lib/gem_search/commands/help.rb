module Gem::Search::Commands
  class Help < Base
    def call
      puts @options
    end
  end
end
