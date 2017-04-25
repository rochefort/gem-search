BIN = "exe/gem-search"

USAGE = <<-EOS
Usage: gem-search gem_name [options]

    -s, --sort     Sort by the field.
                     default [a]ll
                     [a]ll  :DL(all)  e.g.: gem-search webkit -s a
                     [v]er  :DL(ver)  e.g.: gem-search webkit -s v
                     [n]ame :         e.g.: gem-search webkit -s n
    -b, --browse   Open rubygem's homepage in the system's default web browser.
    --no-homepage  Do not show rubygems's homepage url.
    -v, --version  Display the version.
    -h, --help     Display this help message.
EOS

RSpec.describe "exe/gem-search" do
  shared_examples "display an usage" do
    it "display an usage" do
      should == USAGE
    end
  end

  context "with no argument" do
    subject { `#{BIN}` }
    it_behaves_like "display an usage"
  end

  context "with -h" do
    subject { `#{BIN} -h` }
    it_behaves_like "display an usage"
  end

  context "with -x(non-exisitng option)" do
    subject { `#{BIN} -x` }
    it_behaves_like "display an usage"
  end

  context "with -v" do
    subject { `#{BIN} -v` }
    it "display an usage" do
      should == "gem-search #{GemSearch::VERSION}\n"
    end
  end
end
