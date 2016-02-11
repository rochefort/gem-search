include Gem::Search

RSpec.describe Commands::Browse do
  describe '#call' do
    before do
      @executor = Executor.new
      allow(Executor).to receive(:new).and_return(@executor)
      @options = { browse: query }
    end

    let(:query) { 'factory_girl' }

    context 'with browse option' do
      it 'called Executor#browse with browse option' do
        expect(@executor).to receive(:browse).with(query).once
        Commands::Browse.new(@options).call
      end
    end
  end
end
