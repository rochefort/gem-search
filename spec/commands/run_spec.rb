require 'spec_helper'

include Gem::Search

RSpec.describe Commands::Run do
  describe '#call' do
    before do
      @executor = Executor.new
      allow(Executor).to receive(:new).and_return(@executor)
      @options = {}
      allow(@options).to receive(:arguments).and_return([query])
      allow(@options).to receive(:detail?).and_return(false)
      stub_request_search(query, 1, dummy_search_result)
      stub_request_search_no_result_with_page(query, 2)
    end

    let(:query) { 'factory_girl' }

    context 'without sort option' do
      it 'called Executor#search without sort option' do
        expect(@executor).to receive(:search).with(query, default_opts).once
        Commands::Run.new(@options).call
      end
    end

    context 'with sort option' do
      before do
        allow(@options).to receive(:sort).and_return('a')
      end
      it 'called Executor#search with sort option' do
        expect(@executor).to receive(:search).with(query, default_opts(sort: 'downloads')).once
        Commands::Run.new(@options).call
      end
    end
  end
end
