require 'spec_helper'

BIN = 'bin/gem-search'
USAGE = <<-EOS
Usage: gem-search gem_name [options]

    -s, --sort         Sort by name of item.
                        [n]ame (default)
                        [v]er  (displayed name: DL(ver))
                        [a]ll  (displayed name: DL(all))
    -v, --version      Display the version.
    -h, --help         Display this help message.
EOS


shared_examples 'display an usage' do
  it 'should display an usage' do
    should == USAGE
  end
end

describe 'bin/gem-search' do
  context 'with no argument' do
    subject { `#{BIN}` }
    it_behaves_like 'display an usage'
  end

  context 'with -h' do
    subject { `#{BIN} -h` }
    it_behaves_like 'display an usage'
  end

  context 'with -v' do
    subject { `#{BIN} -v` }
    it 'should display an usage' do
      should == "gem-search #{Gem::Search::VERSION}\n"
    end
  end

end
