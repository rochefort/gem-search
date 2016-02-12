include Gem::Search

RSpec.describe Executor do
  let(:executor) { Executor.new }

  describe '#search' do
    context 'when a network error occurred' do
      before do
        stub_request(:get, build_search_uri(query, 1))
          .to_return(status: 500, body: '[]')
      end
      let(:query) { 'network_error_orccurred' }
      it { expect { executor.search(query) }.to raise_error(Exception) }
    end

    context 'when no matching gem' do
      before { stub_request_search_no_result_with_page(query, 1) }
      let(:query) { 'no_match_gem_name' }
      it { expect { executor.search(query, default_opts) }.to raise_error(LibraryNotFound) }
    end

    describe 'with detail' do
      before do
        stub_request_search(query, 1, dummy_search_result)
        stub_request_search_no_result_with_page(query, 2)
      end
      let(:query) { 'factory_girl' }

      context 'with no sort option' do
        it 'display rubygems ordering by DL(all)' do
          res = <<-'EOS'.unindent
            |Searching .
            |NAME                                                DL(ver)   DL(all) HOMEPAGE                                                    
            |-------------------------------------------------- -------- --------- ------------------------------------------------------------
            |factory_girl (3.6.0)                                    541   2042859 https://github.com/thoughtbot/factory_girl                  
            |factory_girl_rails (3.5.0)                            39724   1238780 http://github.com/thoughtbot/factory_girl_rails             
            |factory_girl_generator (0.0.3)                         8015     15547 http://github.com/leshill/factory_girl_generator            
          EOS
          expect { executor.search(query, default_opts(detail: true)) }.to output(res).to_stdout
        end
      end
    end

    describe 'sorting' do
      before do
        stub_request_search(query, 1, dummy_search_result)
        stub_request_search_no_result_with_page(query, 2)
      end
      let(:query) { 'factory_girl' }

      context 'with no sort option' do
        it 'display rubygems ordering by DL(all)' do
          res = <<-'EOS'.unindent
            |Searching .
            |NAME                                                DL(ver)   DL(all)
            |-------------------------------------------------- -------- ---------
            |factory_girl (3.6.0)                                    541   2042859
            |factory_girl_rails (3.5.0)                            39724   1238780
            |factory_girl_generator (0.0.3)                         8015     15547
          EOS
          expect { executor.search(query, default_opts) }.to output(res).to_stdout
        end
      end

      context 'with sort option: [a]download' do
        it 'display rubygems ordering by DL(all)' do
          res = <<-'EOS'.unindent
            |Searching .
            |NAME                                                DL(ver)   DL(all)
            |-------------------------------------------------- -------- ---------
            |factory_girl (3.6.0)                                    541   2042859
            |factory_girl_rails (3.5.0)                            39724   1238780
            |factory_girl_generator (0.0.3)                         8015     15547
          EOS
          expect { executor.search(query, default_opts) }.to output(res).to_stdout
        end
      end

      context 'with sort option: [v]version_downloads' do
        it 'display rubygems ordering by DL(ver)' do
          res = <<-'EOS'.unindent
            |Searching .
            |NAME                                                DL(ver)   DL(all)
            |-------------------------------------------------- -------- ---------
            |factory_girl_rails (3.5.0)                            39724   1238780
            |factory_girl_generator (0.0.3)                         8015     15547
            |factory_girl (3.6.0)                                    541   2042859
          EOS
          expect { executor.search(query, default_opts(sort: 'version_downloads')) }.to output(res).to_stdout
        end
      end

      context 'with sort option: [n]ame' do
        it 'display rubygems ordering by name' do
          res = <<-'EOS'.unindent
            |Searching .
            |NAME                                                DL(ver)   DL(all)
            |-------------------------------------------------- -------- ---------
            |factory_girl (3.6.0)                                    541   2042859
            |factory_girl_generator (0.0.3)                         8015     15547
            |factory_girl_rails (3.5.0)                            39724   1238780
          EOS
          expect { executor.search(query, default_opts(sort: 'name')) }.to output(res).to_stdout
        end
      end
    end

    describe 'multiple page' do
      before do
        stub_request_search(query, 1, load_http_stubs('search/cucumber-_1.json'))
        stub_request_search(query, 2, load_http_stubs('search/cucumber-_2.json'))
        stub_request_search(query, 3, load_http_stubs('search/cucumber-_3.json'))
        stub_request_search_no_result_with_page(query, 4)
      end
      let(:query) { 'cucumber-' }
      it 'display rubygems ordering by name' do
        res = <<-'EOS'.unindent
          |Searching ...
          |NAME                                                DL(ver)   DL(all)
          |-------------------------------------------------- -------- ---------
          |autotest-cucumber-notification (0.0.6)                 1027      3607
          |calabash-cucumber-cn (0.0.6)                             88        88
          |cucumber-ajaxer (0.0.4)                                1875      4966
          |cucumber-api-steps (0.13)                              1783     36587
          |cucumber-blanket (0.3.0)                                324      1674
          |cucumber-cafe (0.0.1)                                   295       295
          |cucumber-chef (3.0.8)                                  1545     28881
          |cucumber-cinema (0.8.0)                                1309      9294
          |cucumber-core (0.2.0)                                   316       683
          |cucumber-core (0.2.0)                                   316       683
          |cucumber-debug (0.0.1)                                 1702      1702
          |cucumber-en_snippet (0.0.2)                             295       565
          |cucumber-farmer (1.0.3)                                1573      4398
          |cucumber-formatter-oneline (0.1.0)                      413       413
          |cucumber-in-the-yard (1.7.8)                           2107     33260
          |cucumber-java (0.0.2)                                  2113      3656
          |cucumber-jira (0.0.1.beta)                              166       166
          |cucumber-json (0.0.2)                                  2199      3697
          |cucumber-jvm (1.1.6)                                    204     20913
          |cucumber-loggly (0.3.1)                                 903      4869
          |cucumber-mingle (1.0.0)                                1539      1539
          |cucumber-nagios (0.9.2)                               27094     75277
          |cucumber-nc (0.0.2)                                     162      1362
          |cucumber-newrelic (0.0.2)                              1694      3201
          |cucumber-notify (0.0.5)                                1168      3348
          |cucumber-openerpscenario (0.1.9.1)                     1110     11064
          |cucumber-peel (0.0.1)                                  1000      1000
          |cucumber-pride (0.0.2)                                 1272      2321
          |cucumber-profiler (1.0.0)                              1171      1171
          |cucumber-puppet (0.3.7)                                2974     24374
          |cucumber-rails (1.4.0)                               286328   2700475
          |cucumber-rails-training-wheels (1.0.0)               109001    109001
          |cucumber-rails2 (0.3.5)                               10776     13172
          |cucumber-rapid7 (0.0.1.beta.1)                          101       430
          |cucumber-rapid7 (0.0.1.beta.1)                          101       430
          |cucumber-relizy (0.0.2)                                1433      2502
          |cucumber-salad (0.4.0)                                  488      5326
          |cucumber-salad (0.4.0)                                  488      5326
          |cucumber-scout (0.0.2)                                 1634      3124
          |cucumber-screenshot (0.3.4)                            2241     15704
          |cucumber-selenium-standalone (0.0.3)                   1322      3593
          |cucumber-sinatra (0.5.0)                               8463     28042
          |cucumber-slice (0.0.2)                                  629      1199
          |cucumber-slices (0.0.4)                                 172       649
          |cucumber-sshd (0.1.0)                                   152       152
          |cucumber-standalone (0.0.1)                            1665      1665
          |cucumber-step_writer (0.1.2)                           1251      3229
          |cucumber-table (0.0.1)                                  527       527
          |cucumber-the (1.0.0)                                   1209      1209
          |cucumber-timecop (0.0.3)                                445       820
          |cucumber-timed_formatter (0.1.1)                       1066      2165
          |cucumber-to-rally (0.1.3)                              1001      3894
          |cucumber-usual_suspects (0.0.1)                        1378      1378
          |cucumber-value (0.0.1)                                 1233      1233
          |cucumber-vimscript (0.0.3)                             1097      3316
          |cucumber-voip (0.1.0)                                  1244      1244
          |cucumber-websteps (0.10.0)                            18583     22129
          |cucumber-wordpress (1.3.1)                             1346      7458
          |guard-cucumber-js (0.0.2)                              1039      1935
          |mattscilipoti-cucumber-rails (0.2.4.2)                 1394      3989
          |mattscilipoti_cucumber-rails (0.2.4)                   1401      1401
          |tasty-cucumber-client (0.1.10)                         1504     11518
          |vagrant-cucumber-host (0.1.14)                          163       163
        EOS
        expect { executor.search(query, default_opts(sort: 'name')) }.to output(res).to_stdout
      end
    end

    describe 'ruled NAME line' do
      context 'NAME size is 42' do
        before do
          stub_request_search(query, 1, dummy_search_result_name_size_is_42)
          stub_request_search_no_result_with_page(query, 2)
        end
        let(:query) { 'size_is_42_2345678901234567890123456789012' }
        it 'is 50 characters' do
          res = <<-'EOS'.unindent
            |Searching .
            |NAME                                                DL(ver)   DL(all)
            |-------------------------------------------------- -------- ---------
            |size_is_42_2345678901234567890123456789012 (0.0.1)      100      1000
          EOS
          expect { executor.search(query, default_opts) }.to output(res).to_stdout
        end
      end

      context 'NAME size is 43' do
        before do
          stub_request_search(query, 1, dummy_search_result_name_size_is_43)
          stub_request_search_no_result_with_page(query, 2)
        end
        let(:query) { 'size_is_43_23456789012345678901234567890123' }
        it 'is 51 characters' do
          res = <<-'EOS'.unindent
            |Searching .
            |NAME                                                 DL(ver)   DL(all)
            |--------------------------------------------------- -------- ---------
            |size_is_43_23456789012345678901234567890123 (0.0.2)      200      2000
          EOS
          expect { executor.search(query, default_opts) }.to output(res).to_stdout
        end
      end
    end
  end

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

  private

  def dummy_search_result_name_size_is_42
    [{
      'name' => 'size_is_42_2345678901234567890123456789012',
      'downloads' => 1000,
      'version' => '0.0.1',
      'version_downloads' => 100
    }].to_json
  end

  def dummy_search_result_name_size_is_43
    [{
      'name' => 'size_is_43_23456789012345678901234567890123',
      'downloads' => 2000,
      'version' => '0.0.2',
      'version_downloads' => 200
    }].to_json
  end
end
