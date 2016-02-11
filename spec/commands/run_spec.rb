require 'spec_helper'

include Gem::Search

RSpec.describe Commands::Run do
  describe '#call' do
    before do
      allow(options).to receive(:arguments).and_return([query])
      allow(options).to receive(:detail?).and_return(false)
      allow(options).to receive(:[]).with('sort')
      stub_request_search(query, 1, dummy_search_result)
      stub_request_search_no_result_with_page(query, 2)
    end
    let(:query) { 'factory_girl' }
    let(:options) { double('options') }

    context 'without sort option' do
      it 'called Executor#search without sort option' do
        expect_any_instance_of(Executor).to receive(:search).with(query, default_opts).once
        Commands::Run.new(options).call
      end
    end

    context 'with sort option' do
      before { allow(@options).to receive(:sort).and_return('a') }
      it 'called Executor#search with sort option' do
        expect_any_instance_of(Executor).to receive(:search).with(query, default_opts(sort: 'downloads')).once
        Commands::Run.new(options).call
      end
    end
  end
end
