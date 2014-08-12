module Gem::Search
  module Rendering
    DEFAULT_RULED_LINE_SIZE = [50, 8, 9]

    def self.included(base)
      base.extend(self)
    end

    def render(gems)
      ruled_line_size(gems)
      render_to_header
      render_to_body(gems)
    end

    private

    def ruled_line_size(gems)
      max_name_size = gems.map { |gem| "#{gem['name'] } (#{gem['version']})".size }.max
      DEFAULT_RULED_LINE_SIZE[0] = max_name_size if max_name_size > DEFAULT_RULED_LINE_SIZE[0]
    end

    def render_to_header
      f = DEFAULT_RULED_LINE_SIZE
      fmt = "%-#{f[0]}s %#{f[1]}s %#{f[2]}s"
      puts fmt % ['NAME', 'DL(ver)', 'DL(all)']
      puts fmt % ['-'*f[0], '-'*f[1], '-'*f[2]]
    end

    def render_to_body(gems)
      f = DEFAULT_RULED_LINE_SIZE
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
