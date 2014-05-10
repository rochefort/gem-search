# -*- encoding: utf-8 -*-
require 'rubygems'
require 'simplecov'
SimpleCov.start

require 'webmock/rspec'
require 'gem-search'

# http://d.hatena.ne.jp/POCHI_BLACK/20100324
# this method is written by wycats
def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end

def load_http_stubs(file_name)
  open(File.join(File.dirname(__FILE__), 'http_stubs', file_name)).read
end

class String
  def unindent
    gsub(/^\s+\|/, '')
  end
end