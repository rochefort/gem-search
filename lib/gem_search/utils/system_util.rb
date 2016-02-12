module GemSearch::Utils
  module SystemUtil
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
  end
end
