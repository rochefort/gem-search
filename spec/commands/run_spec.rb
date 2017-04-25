include GemSearch

RSpec.describe Commands::Run do
  shared_examples "sort example by all" do |sort_option|
    before { allow(options).to receive(:[]).with("sort").and_return(sort_option) }
    it "display rubygems sorted by DL(all)" do
      expect { Commands::Run.new(options).call }.to output(dummy_search_result_sorted_by_all).to_stdout
    end
  end

  shared_examples "sort example by ver" do |sort_option|
    before { allow(options).to receive(:[]).with("sort").and_return(sort_option) }
    it "display rubygems sorted by DL(ver)" do
      expect { Commands::Run.new(options).call }.to output(dummy_search_result_sorted_by_ver).to_stdout
    end
  end

  shared_examples "sort example by name" do |sort_option|
    before { allow(options).to receive(:[]).with("sort").and_return(sort_option) }
    it "display rubygems sorted by NAME" do
      expect { Commands::Run.new(options).call }.to output(dummy_search_result_sorted_by_name).to_stdout
    end
  end

  describe "#call" do
    before do
      allow(options).to receive(:arguments).and_return([query])
      allow(options).to receive(:[]).with("exact").and_return(false)
      allow(options).to receive(:[]).with("no-homepage")
      allow(options).to receive(:[]).with("sort")
    end
    let(:options) { double("options") }

    context "when a network error occurred" do
      before do
        stub_request(:get, build_search_uri(query, 1))
          .to_return(status: 500, body: "[]")
      end
      let(:query) { "network_error_orccurred" }
      it { expect { Commands::Run.new(options).call }.to raise_error(SystemExit) }
    end

    context "when no matching gem" do
      before { stub_request_search_no_result_with_page(query, 1) }
      let(:query) { "no_matching_gem_name" }
      it { expect { Commands::Run.new(options).call }.to raise_error(SystemExit) }
    end

    describe "with no-homepage option" do
      before do
        allow(options).to receive(:[]).with("no-homepage").and_return(true)
        stub_request_search(query, 1, dummy_search_result)
        stub_request_search_no_result_with_page(query, 2)
      end
      let(:query) { "factory_girl" }

      context "with no sort option" do
        it "display rubygems ordering by DL(all)" do
          res = <<-'EOS'.unindent
            |Searching .
            |NAME                                                DL(ver)   DL(all)
            |-------------------------------------------------- -------- ---------
            |factory_girl (3.6.0)                                    541   2042859
            |factory_girl_rails (3.5.0)                            39724   1238780
            |factory_girl_generator (0.0.3)                         8015     15547
          EOS
          expect { Commands::Run.new(options).call }.to output(res).to_stdout
        end
      end
    end

    describe "sorting" do
      before do
        stub_request_search(query, 1, dummy_search_result)
        stub_request_search_no_result_with_page(query, 2)
      end
      let(:query) { "factory_girl" }

      describe "sort by all" do
        context "with no sort option" do
          include_examples "sort example by all", nil
        end

        context "with disallowed sort option" do
          include_examples "sort example by all", "xyz"
        end

        context "with a" do
          include_examples "sort example by all", "a"
        end

        context "with all" do
          include_examples "sort example by all", "all"
        end

        context "with ALL" do
          include_examples "sort example by all", "ALL"
        end
      end

      describe "sort by ver" do
        context "with v" do
          include_examples "sort example by ver", "v"
        end

        context "with ver" do
          include_examples "sort example by ver", "ver"
        end

        context "with VER" do
          include_examples "sort example by ver", "VER"
        end
      end

      describe "sort by name" do
        context "with n" do
          include_examples "sort example by name", "n"
        end

        context "with name" do
          include_examples "sort example by name", "name"
        end

        context "with NAME" do
          include_examples "sort example by name", "NAME"
        end
      end
    end

    describe "multiple page" do
      before do
        allow(options).to receive(:[]).with("sort").and_return("name")
        stub_request_search(query, 1, load_http_stubs("search/cucumber-_1.json"))
        stub_request_search(query, 2, load_http_stubs("search/cucumber-_2.json"))
        stub_request_search(query, 3, load_http_stubs("search/cucumber-_3.json"))
        stub_request_search_no_result_with_page(query, 4)
      end
      let(:query) { "cucumber-" }
      it "display rubygems ordering by name" do
        expect { Commands::Run.new(options).call }.to output(dummy_search_results_multiple_pages).to_stdout
      end
    end

    describe "exact matching" do
      before do
        allow(options).to receive(:[]).with("exact").and_return(true)
        stub_request_search(query, 1, dummy_search_result)
        stub_request_search_no_result_with_page(query, 2)
      end

      context "results is only 1page" do
        let(:query) { "factory_girl" }
        it "display the specified rubygem" do
          res = <<-'EOS'.unindent
            |Searching .
            |NAME                                                DL(ver)   DL(all) HOMEPAGE                                                    
            |-------------------------------------------------- -------- --------- ------------------------------------------------------------
            |factory_girl (3.6.0)                                    541   2042859 https://github.com/thoughtbot/factory_girl                  
          EOS
          expect { Commands::Run.new(options).call }.to output(res).to_stdout
        end
      end

      describe "multiple page" do
        before do
          stub_request_search(query, 1, load_http_stubs("search/kaminari_1.json"))
          stub_request_search(query, 2, load_http_stubs("search/kaminari_2.json"))
          stub_request_search_no_result_with_page(query, 3)
        end
        let(:query) { "kaminari" }
        it "display the specified rubygem" do
          res = <<-'EOS'.unindent
            |Searching ..
            |NAME                                                DL(ver)   DL(all) HOMEPAGE                                                    
            |-------------------------------------------------- -------- --------- ------------------------------------------------------------
            |kaminari (1.0.1)                                     398699  17925148 https://github.com/kaminari/kaminari                        
          EOS
          expect { Commands::Run.new(options).call }.to output(res).to_stdout
        end
      end
    end

    describe "ruled NAME line" do
      context "NAME size is 42" do
        before do
          stub_request_search(query, 1, dummy_search_result_name_size_is_42)
          stub_request_search_no_result_with_page(query, 2)
        end
        let(:query) { "size_is_42_2345678901234567890123456789012" }
        it "is 50 characters" do
          # rubocop:disable Metrics/LineLength, Style/TrailingWhitespace
          res = <<-'EOS'.unindent
            |Searching .
            |NAME                                                DL(ver)   DL(all) HOMEPAGE                                                    
            |-------------------------------------------------- -------- --------- ------------------------------------------------------------
            |size_is_42_2345678901234567890123456789012 (0.0.1)      100      1000                                                             
          EOS
          # rubocop:enable Metrics/LineLength, Style/TrailingWhitespace
          expect { Commands::Run.new(options).call }.to output(res).to_stdout
        end
      end
    end

    context "NAME size is 43" do
      before do
        stub_request_search(query, 1, dummy_search_result_name_size_is_43)
        stub_request_search_no_result_with_page(query, 2)
      end
      let(:query) { "size_is_43_23456789012345678901234567890123" }
      it "is 51 characters" do
        # rubocop:disable Metrics/LineLength, Style/TrailingWhitespace
        res = <<-'EOS'.unindent
          |Searching .
          |NAME                                                 DL(ver)   DL(all) HOMEPAGE                                                    
          |--------------------------------------------------- -------- --------- ------------------------------------------------------------
          |size_is_43_23456789012345678901234567890123 (0.0.2)      200      2000                                                             
        EOS
        # rubocop:enable Metrics/LineLength, Style/TrailingWhitespace
        expect { Commands::Run.new(options).call }.to output(res).to_stdout
      end
    end
  end
end
