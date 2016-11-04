include GemSearch

RSpec.describe Commands::Browse do
  describe "#call" do
    let(:query) { "factory_girl" }
    let(:options) { { browse: query } }

    context "when a network error occurred" do
      before do
        stub_request(:get, build_gems_uri(query))
          .to_return(status: 500, body: "[]")
      end
      let(:query) { "network_error_orccurred" }
      it { expect { Commands::Browse.new(options).call }.to raise_error(Exception) }
    end

    context "when no matching gem" do
      before { stub_request_gems_no_result(query) }
      let(:query) { "no_match_gem_name" }
      it { expect { Commands::Browse.new(options).call }.to raise_error(SystemExit) }
    end

    context "when no homepage_uri" do
      before do
        http_stub = load_http_stubs("gems/#{query}.json")
        stub_request_gems(query, http_stub)
      end
      let(:query) { "git-trend_no_homepage" }
      let(:uri) { Commands::Browse::GEM_URL % query }
      it "open a rubygems uri" do
        expect_any_instance_of(Kernel).to receive(:system).with(anything, uri)
        Commands::Browse.new(options).call
      end
    end

    context "when homepage_uri is existed" do
      before do
        http_stub = load_http_stubs("gems/#{query}.json")
        @uri = JSON.parse(http_stub)["homepage_uri"]
        stub_request_gems(query, http_stub)
      end
      let(:query) { "git-trend" }
      let(:uri) { @uri }
      it "open a homepage uri" do
        expect_any_instance_of(Kernel).to receive(:system).with(anything, uri)
        Commands::Browse.new(options).call
      end
    end
  end
end
