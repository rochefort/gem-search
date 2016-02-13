include GemSearch

RSpec.describe Commands::Run do
  shared_examples 'sort example by all' do |sort_option|
    before { allow(options).to receive(:[]).with('sort').and_return(sort_option) }
    it 'display rubygems sorted by DL(all)' do
      expect { Commands::Run.new(options).call }.to output(dummy_search_result_sorted_by_all).to_stdout
    end
  end

  shared_examples 'sort example by ver' do |sort_option|
    before { allow(options).to receive(:[]).with('sort').and_return(sort_option) }
    it 'display rubygems sorted by DL(ver)' do
      expect { Commands::Run.new(options).call }.to output(dummy_search_result_sorted_by_ver).to_stdout
    end
  end

  shared_examples 'sort example by name' do |sort_option|
    before { allow(options).to receive(:[]).with('sort').and_return(sort_option) }
    it 'display rubygems sorted by NAME' do
      expect { Commands::Run.new(options).call }.to output(dummy_search_result_sorted_by_name).to_stdout
    end
  end

  describe '#call' do
    before do
      allow(options).to receive(:arguments).and_return([query])
      allow(options).to receive(:[]).with('no-homepage')
      allow(options).to receive(:[]).with('sort')
    end
    let(:options) { double('options') }

    context 'when a network error occurred' do
      before do
        stub_request(:get, build_search_uri(query, 1))
          .to_return(status: 500, body: '[]')
      end
      let(:query) { 'network_error_orccurred' }
      it { expect { Commands::Run.new(options).call }.to raise_error(SystemExit) }
    end

    context 'when no matching gem' do
      before { stub_request_search_no_result_with_page(query, 1) }
      let(:query) { 'no_matching_gem_name' }
      it { expect { Commands::Run.new(options).call }.to raise_error(SystemExit) }
    end

    describe 'with no-homepage option' do
      before do
        allow(options).to receive(:[]).with('no-homepage').and_return(true)
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
          expect { Commands::Run.new(options).call }.to output(res).to_stdout
        end
      end
    end

    describe 'sorting' do
      before do
        stub_request_search(query, 1, dummy_search_result)
        stub_request_search_no_result_with_page(query, 2)
      end
      let(:query) { 'factory_girl' }

      describe 'sort by all' do
        context 'with no sort option' do
          include_examples 'sort example by all', nil
        end

        context 'with disallowed sort option' do
          include_examples 'sort example by all', 'xyz'
        end

        context 'with a' do
          include_examples 'sort example by all', 'a'
        end

        context 'with all' do
          include_examples 'sort example by all', 'all'
        end

        context 'with ALL' do
          include_examples 'sort example by all', 'ALL'
        end
      end

      describe 'sort by ver' do
        context 'with v' do
          include_examples 'sort example by ver', 'v'
        end

        context 'with ver' do
          include_examples 'sort example by ver', 'ver'
        end

        context 'with VER' do
          include_examples 'sort example by ver', 'VER'
        end
      end

      describe 'sort by name' do
        context 'with n' do
          include_examples 'sort example by name', 'n'
        end

        context 'with name' do
          include_examples 'sort example by name', 'name'
        end

        context 'with NAME' do
          include_examples 'sort example by name', 'NAME'
        end
      end
    end

    describe 'multiple page' do
      before do
        allow(options).to receive(:[]).with('sort').and_return('name')
        stub_request_search(query, 1, load_http_stubs('search/cucumber-_1.json'))
        stub_request_search(query, 2, load_http_stubs('search/cucumber-_2.json'))
        stub_request_search(query, 3, load_http_stubs('search/cucumber-_3.json'))
        stub_request_search_no_result_with_page(query, 4)
      end
      let(:query) { 'cucumber-' }
      it 'display rubygems ordering by name' do
        expect { Commands::Run.new(options).call }.to output(dummy_search_results_multiple_pages).to_stdout
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
            |NAME                                                DL(ver)   DL(all) HOMEPAGE                                                    
            |-------------------------------------------------- -------- --------- ------------------------------------------------------------
            |size_is_42_2345678901234567890123456789012 (0.0.1)      100      1000                                                             
          EOS
          expect { Commands::Run.new(options).call }.to output(res).to_stdout
        end
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
          |NAME                                                 DL(ver)   DL(all) HOMEPAGE                                                    
          |--------------------------------------------------- -------- --------- ------------------------------------------------------------
          |size_is_43_23456789012345678901234567890123 (0.0.2)      200      2000                                                             
        EOS
        expect { Commands::Run.new(options).call }.to output(res).to_stdout
      end
    end
  end

  private

  def dummy_search_result_sorted_by_all
    <<-'EOS'.unindent
      |Searching .
      |NAME                                                DL(ver)   DL(all) HOMEPAGE                                                    
      |-------------------------------------------------- -------- --------- ------------------------------------------------------------
      |factory_girl (3.6.0)                                    541   2042859 https://github.com/thoughtbot/factory_girl                  
      |factory_girl_rails (3.5.0)                            39724   1238780 http://github.com/thoughtbot/factory_girl_rails             
      |factory_girl_generator (0.0.3)                         8015     15547 http://github.com/leshill/factory_girl_generator            
    EOS
  end

  def dummy_search_result_sorted_by_ver
    <<-'EOS'.unindent
      |Searching .
      |NAME                                                DL(ver)   DL(all) HOMEPAGE                                                    
      |-------------------------------------------------- -------- --------- ------------------------------------------------------------
      |factory_girl_rails (3.5.0)                            39724   1238780 http://github.com/thoughtbot/factory_girl_rails             
      |factory_girl_generator (0.0.3)                         8015     15547 http://github.com/leshill/factory_girl_generator            
      |factory_girl (3.6.0)                                    541   2042859 https://github.com/thoughtbot/factory_girl                  
    EOS
  end

  def dummy_search_result_sorted_by_name
    <<-'EOS'.unindent
      |Searching .
      |NAME                                                DL(ver)   DL(all) HOMEPAGE                                                    
      |-------------------------------------------------- -------- --------- ------------------------------------------------------------
      |factory_girl (3.6.0)                                    541   2042859 https://github.com/thoughtbot/factory_girl                  
      |factory_girl_generator (0.0.3)                         8015     15547 http://github.com/leshill/factory_girl_generator            
      |factory_girl_rails (3.5.0)                            39724   1238780 http://github.com/thoughtbot/factory_girl_rails             
    EOS
  end

  def dummy_search_results_multiple_pages
    <<-'EOS'.unindent
      |Searching ...
      |NAME                                                DL(ver)   DL(all) HOMEPAGE                                                    
      |-------------------------------------------------- -------- --------- ------------------------------------------------------------
      |autotest-cucumber-notification (0.0.6)                 1027      3607 https://github.com/evrone/autotest-cucumber-notification    
      |calabash-cucumber-cn (0.0.6)                             88        88 http://github.com/cpunion/calabash-cucumber-cn              
      |cucumber-ajaxer (0.0.4)                                1875      4966 http://github.com/chalofa/cucumber-ajaxer                   
      |cucumber-api-steps (0.13)                              1783     36587 http://github.com/jayzes/cucumber-api-steps                 
      |cucumber-blanket (0.3.0)                                324      1674 https://github.com/keyvanfatehi/cucumber-blanket            
      |cucumber-cafe (0.0.1)                                   295       295                                                             
      |cucumber-chef (3.0.8)                                  1545     28881 http://www.cucumber-chef.org                                
      |cucumber-cinema (0.8.0)                                1309      9294 http://github.com/ilyakatz/cucumber-cinema                  
      |cucumber-core (0.2.0)                                   316       683 http://cukes.info                                           
      |cucumber-core (0.2.0)                                   316       683 http://cukes.info                                           
      |cucumber-debug (0.0.1)                                 1702      1702                                                             
      |cucumber-en_snippet (0.0.2)                             295       565 https://github.com/mtsmfm/cucumber-en_snippet               
      |cucumber-farmer (1.0.3)                                1573      4398 http://github.com/mattscilipoti/cucumber-farmer             
      |cucumber-formatter-oneline (0.1.0)                      413       413                                                             
      |cucumber-in-the-yard (1.7.8)                           2107     33260 http://github.com/burtlo/Cucumber-In-The-Yard               
      |cucumber-java (0.0.2)                                  2113      3656 http://cukes.info                                           
      |cucumber-jira (0.0.1.beta)                              166       166 https://github.com/ipwnstuff/cucumber-jira                  
      |cucumber-json (0.0.2)                                  2199      3697 http://github.com/jnewland/cucumber-json                    
      |cucumber-jvm (1.1.6)                                    204     20913 http://github.com/cucumber/cucumber-jvm                     
      |cucumber-loggly (0.3.1)                                 903      4869 https://github.com/brettweavnet/cucumber-loggly             
      |cucumber-mingle (1.0.0)                                1539      1539                                                             
      |cucumber-nagios (0.9.2)                               27094     75277 http://cucumber-nagios.org/                                 
      |cucumber-nc (0.0.2)                                     162      1362 https://github.com/MrJoy/cucumber-nc                        
      |cucumber-newrelic (0.0.2)                              1694      3201 http://github.com/jnewland/cucumber-newrelic                
      |cucumber-notify (0.0.5)                                1168      3348 https://github.com/argent-smith/autotest-cucumber-notification/tree/deprecated
      |cucumber-openerpscenario (0.1.9.1)                     1110     11064                                                             
      |cucumber-peel (0.0.1)                                  1000      1000 https://github.com/testdouble/cucumber-peel                 
      |cucumber-pride (0.0.2)                                 1272      2321 https://github.com/pvdb/cucumber-pride                      
      |cucumber-profiler (1.0.0)                              1171      1171 https://github.com/mblum14/cucumber-profiler                
      |cucumber-puppet (0.3.7)                                2974     24374 http://projects.puppetlabs.com/projects/cucumber-puppet     
      |cucumber-rails (1.4.0)                               286328   2700475 http://cukes.info                                           
      |cucumber-rails-training-wheels (1.0.0)               109001    109001 http://cukes.info                                           
      |cucumber-rails2 (0.3.5)                               10776     13172 https://github.com/Vanuan/cucumber-rails                    
      |cucumber-rapid7 (0.0.1.beta.1)                          101       430 https://github.com/ecarey-r7/cucumber-rapid7                
      |cucumber-rapid7 (0.0.1.beta.1)                          101       430 https://github.com/ecarey-r7/cucumber-rapid7                
      |cucumber-relizy (0.0.2)                                1433      2502 https://github.com/wynst/cucumber-relizy                    
      |cucumber-salad (0.4.0)                                  488      5326 https://github.com/mojotech/cucumber-salad                  
      |cucumber-salad (0.4.0)                                  488      5326 https://github.com/mojotech/cucumber-salad                  
      |cucumber-scout (0.0.2)                                 1634      3124 http://github.com/jnewland/cucumber-scout                   
      |cucumber-screenshot (0.3.4)                            2241     15704 http://github.com/mocoso/cucumber-screenshot                
      |cucumber-selenium-standalone (0.0.3)                   1322      3593 http://github.com/techwhizbang/cucumber-selenium-standalone 
      |cucumber-sinatra (0.5.0)                               8463     28042 http://github.com/bernd/cucumber-sinatra                    
      |cucumber-slice (0.0.2)                                  629      1199 https://github.com/testdouble/cucumber-slice                
      |cucumber-slices (0.0.4)                                 172       649 http://github.com/psytau/cucumber-slices                    
      |cucumber-sshd (0.1.0)                                   152       152 https://rubygems.org/gems/cucumber-sshd                     
      |cucumber-standalone (0.0.1)                            1665      1665 http://github.com/jnewland/cucumber-standalone              
      |cucumber-step_writer (0.1.2)                           1251      3229                                                             
      |cucumber-table (0.0.1)                                  527       527                                                             
      |cucumber-the (1.0.0)                                   1209      1209                                                             
      |cucumber-timecop (0.0.3)                                445       820 https://github.com/zedtux/cucumber-timecop                  
      |cucumber-timed_formatter (0.1.1)                       1066      2165 http://github.com/kronn/cucumber-timed_formatter            
      |cucumber-to-rally (0.1.3)                              1001      3894                                                             
      |cucumber-usual_suspects (0.0.1)                        1378      1378 http://github.com/mattwynne/cucumber-usual_suspects         
      |cucumber-value (0.0.1)                                 1233      1233 https://github.com/hatofmonkeys/cucumber-value              
      |cucumber-vimscript (0.0.3)                             1097      3316 http://github.com/AndrewRadev/cucumber-vimscript            
      |cucumber-voip (0.1.0)                                  1244      1244 https://github.com/benlangfeld/cucumber-voip                
      |cucumber-websteps (0.10.0)                            18583     22129 http://relishapp.com/kucaahbe/cucumber-websteps             
      |cucumber-wordpress (1.3.1)                             1346      7458 http://github.com/dxw/cucumber-wordpress                    
      |guard-cucumber-js (0.0.2)                              1039      1935                                                             
      |mattscilipoti-cucumber-rails (0.2.4.2)                 1394      3989 http://github.com/aslakhellesoy/cucumber-rails              
      |mattscilipoti_cucumber-rails (0.2.4)                   1401      1401 http://github.com/aslakhellesoy/cucumber-rails              
      |tasty-cucumber-client (0.1.10)                         1504     11518 http://tasty-cucumber.com                                   
      |vagrant-cucumber-host (0.1.14)                          163       163                                                             
    EOS
  end

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
