include GemSearch

RSpec.describe Commands::Run do
  shared_examples 'sort example' do |expected_option, actual_option|
    before { allow(options).to receive(:[]).with('sort').and_return(actual_option) }
    it 'called Executor#search with sort option' do
      expect_any_instance_of(Executor).to receive(:search).with(query, default_opts(sort: expected_option)).once
      Commands::Run.new(options).call
    end
  end

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

    describe 'sort option' do
      describe 'sort by all' do
        context 'without sort option' do
          include_examples 'sort example', 'downloads', nil
        end
        context 'with disalbe sort option' do
          include_examples 'sort example', 'downloads', 'xyz'
        end
        context 'with a' do
          include_examples 'sort example', 'downloads', 'a'
        end
        context 'with all' do
          include_examples 'sort example', 'downloads', 'all'
        end
        context 'with ALL' do
          include_examples 'sort example', 'downloads', 'ALL'
        end
      end
    end

    describe 'sort by name' do
      context 'with n' do
        include_examples 'sort example', 'name', 'n'
      end
      context 'with name' do
        include_examples 'sort example', 'name', 'name'
      end
      context 'with NAME' do
        include_examples 'sort example', 'name', 'NAME'
      end
    end

    describe 'sort by ver' do
      context 'with v' do
        include_examples 'sort example', 'version_downloads', 'v'
      end
      context 'with ver' do
        include_examples 'sort example', 'version_downloads', 'ver'
      end
      context 'with version' do
        include_examples 'sort example', 'version_downloads', 'version'
      end
      context 'with VER' do
        include_examples 'sort example', 'version_downloads', 'VER'
      end
    end
  end
end
