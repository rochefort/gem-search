require 'spec_helper'

include Gem::Search

RSpec.describe Command do
  describe '#run' do
    before do
      @executor = Executor.new
      allow(Executor).to receive(:new).and_return(@executor)
      allow(ARGV).to receive(:[]).with(0).and_return(query)
      stub_request_search(1, dummy_search_result)
      stub_request_no_result_with_page(2)
    end
    let(:query) {'factory_girl'}

    context 'with no sort option' do
      before do
        allow(Command::OPTS).to receive(:[]).and_return(nil)
      end
      it 'called with no sort option' do
        expect(@executor).to receive(:search).with(query).once
        Command.new.run
      end
    end

    context 'with sort option' do
      before do
        allow(Command::OPTS).to receive(:[]).and_return(nil)
        allow(Command::OPTS).to receive(:[]).with('sort').and_return('a')
      end
      it 'called with sort option' do
        expect(@executor).to receive(:search).with(query, 'downloads').once
        Command.new.run
      end
    end
  end
end
