require 'spec_helper'

include Gem::Search

describe Command do
  describe '#run' do
    before do
      @executor = Executor.new
      Executor.should_receive(:new).and_return(@executor)
      ARGV.stub(:[]).with(0).and_return(query)
      stub_request_search(1, dummy_search_result)
      stub_request_no_result_with_page(2)
    end
    let(:query) {'factory-girl'}

    context 'with no sort option' do
      before do
        Command::OPTS.stub(:[]).and_return(nil)
      end
      it 'called with no sort option' do
        @executor.should_receive(:search).with(query).once
        Command.new.run
      end
    end

    context 'with sort option' do
      before do
        Command::OPTS.stub(:[]).and_return(nil)
        Command::OPTS.stub(:[]).with('sort').and_return('a')
      end
      it 'called with sort option' do
        @executor.should_receive(:search).with(query, 'downloads').once
        Command.new.run
      end
    end
  end
end
