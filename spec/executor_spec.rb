include GemSearch

RSpec.describe Executor do
  let(:executor) { Executor.new }

  describe '#browse' do
    context 'when a network error occurred' do
      before do
        stub_request(:get, build_gems_uri(query))
          .to_return(status: 500, body: '[]')
      end
      let(:query) { 'network_error_orccurred' }
      it { expect { executor.browse(query) }.to raise_error(Exception) }
    end

    context 'when no matching gem' do
      before { stub_request_gems_no_result(query) }
      let(:query) { 'no_match_gem_name' }
      it { expect { executor.browse(query) }.to raise_error(OpenURI::HTTPError) }
    end

    context 'when no homepage_uri' do
      before do
        url = Executor::GEM_URL % query
        allow(executor).to receive(:system).with(anything, url)
        stub_request_gems(query, load_http_stubs("gems/#{query}.json"))
      end
      let(:query) { 'git-trend_no_homepage' }

      it 'open a rubygems url' do
        executor.browse(query)
      end
    end

    context 'when homepage_uri is existed' do
      before do
        http_stub = load_http_stubs("gems/#{query}.json")
        url = JSON.parse(http_stub)['homepage_uri']
        allow(executor).to receive(:system).with(anything, url)
        stub_request_gems(query, http_stub)
      end
      let(:query) { 'git-trend' }

      it 'open a homepage url' do
        executor.browse(query)
      end
    end
  end
end
