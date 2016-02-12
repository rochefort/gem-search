module GemSearch
  module Rendering
    # NAME', 'DL(ver)', 'DL(all)', 'HOMEPAGE'
    DEFAULT_RULED_LINE_SIZE = [50, 8, 9, 60]

    def self.included(base)
      base.extend(self)
    end

    def render(gems, opt_detail)
      @opt_detail = opt_detail
      ruled_line_size(gems)
      render_header
      render_body(gems)
    end

    private

    def ruled_line_size(gems)
      @ruled_line_size = DEFAULT_RULED_LINE_SIZE.dup
      max_name_size = gems.map { |gem| "#{gem['name']} (#{gem['version']})".size }.max
      @ruled_line_size[0] = max_name_size if max_name_size > @ruled_line_size[0]
    end

    def render_header
      f = @ruled_line_size
      fmt = "%-#{f[0]}s %#{f[1]}s %#{f[2]}s"
      titles = ['NAME', 'DL(ver)', 'DL(all)']
      hyphens = ['-'*f[0], '-'*f[1], '-'*f[2]]
      if @opt_detail
        fmt << " %-#{f[3]}s"
        titles << 'HOMEPAGE'
        hyphens << '-'*f[3]
      end
      puts fmt % titles
      puts fmt % hyphens
    end

    def render_body(gems)
      f = @ruled_line_size
      fmt = "%-#{f[0]}s %#{f[1]}d %#{f[2]}d"
      fmt << " %-#{f[3]}s" if @opt_detail
      gems.each do |gem|
        columns = [
          "#{gem['name']} (#{gem['version']})",
          gem['version_downloads'],
          gem['downloads']
        ]
        columns << gem['homepage_uri'] if @opt_detail
        puts fmt % columns
      end
    end
  end
end
