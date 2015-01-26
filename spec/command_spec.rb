require 'spec_helper'

include Gem::Search

RSpec.describe Command do
  describe '#run' do
    before do
      @executor = Executor.new
      allow(Executor).to receive(:new).and_return(@executor)
      @bef_args = ARGV
      ARGV = [query]
      stub_request_search(query, 1, dummy_search_result)
      stub_request_search_no_result_with_page(query, 2)
    end
    after do
      ARGV = @bef_args
    end
    let(:query) { 'factory_girl' }

    context 'without sort option' do
      before do
        allow(Command::OPTS).to receive(:[]).and_return(nil)
      end
      it 'called without sort option' do
        expect(@executor).to receive(:search).with(query, default_opts).once
        Command.new.run
      end
    end

    context 'with sort option' do
      before do
        allow(Command::OPTS).to receive(:[]).and_return(nil)
        allow(Command::OPTS).to receive(:[]).with('sort').and_return('a')
      end
      it 'called with sort option' do
        expect(@executor).to receive(:search).with(query, default_opts(sort: 'downloads')).once
        Command.new.run
      end
    end
  end
end
