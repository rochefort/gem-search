require 'spec_helper'

BIN = 'bin/gem-search'
USAGE = <<-EOS
Usage: gem-search gem_name [options]

    -s, --sort         Sort by the item.
                        default [a]ll
                        [a]ll  :DL(all)  eg. gem-search webkit -s a
                        [v]er  :DL(ver)  eg. gem-search webkit -s v
                        [n]ame :         eg. gem-search webkit -s n
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

  context 'with -x(non-exisitng option)' do
    subject { `#{BIN} -x` }
    it_behaves_like 'display an usage'
  end

  context 'with -v' do
    subject { `#{BIN} -v` }
    it 'should display an usage' do
      should == "gem-search #{Gem::Search::VERSION}\n"
    end
  end

end
