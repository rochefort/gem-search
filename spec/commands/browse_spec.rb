include Gem::Search

RSpec.describe Commands::Browse do
  describe '#call' do
    let(:query) { 'factory_girl' }
    let(:options) { { browse: query } }

    context 'with browse option' do
      it 'called Executor#browse with browse option' do
        expect_any_instance_of(Executor).to receive(:browse).with(query).once
        Commands::Browse.new(options).call
      end
    end
  end
end
