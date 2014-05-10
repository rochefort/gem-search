require 'spec_helper'

include Gem::Search

describe Executor do
  describe '#search' do
    before do
      @executor = Gem::Search::Executor.new
      stub_request(:get, build_search_uri('factory_girl')).
        to_return(:status => 200, :body => dummy_search_result)
    end

    context 'when a network error occurred' do
      before do
        stub_request(:get, build_search_uri('network_error_orccurred')).
          to_return(:status => 500, :body => '[]')
      end
      it { expect{ @executor.search('no_match_gem_name') }.to raise_error(Exception) }
    end

    context 'with nonexistence gem' do
      before do
        stub_request(:get, build_search_uri('no_match_gem_name')).
          to_return(:status => 200, :body => '[]')
      end
      it { expect{ @executor.search('no_match_gem_name') }.to raise_error(LibraryNotFound) }
    end

    context 'with existing gem' do
      context 'with no sort option' do
        it 'should display rubygems ordering by name' do
          capture(:stdout) { @executor.search('factory_girl') }.should == <<-'EOS'.unindent
            |NAME                                                DL(ver)   DL(all)
            |-------------------------------------------------- -------- ---------
            |factory_girl (3.6.0)                                    541   2042859
            |factory_girl_generator (0.0.3)                         8015     15547
            |factory_girl_rails (3.5.0)                            39724   1238780
          EOS
        end
      end

      context 'with sort option: [v]version_downloads' do
        it "should display rubygems ordering by name" do
          capture(:stdout) { @executor.search('factory_girl', 'version_downloads') }.should == <<-'EOS'.unindent
            |NAME                                                DL(ver)   DL(all)
            |-------------------------------------------------- -------- ---------
            |factory_girl_rails (3.5.0)                            39724   1238780
            |factory_girl_generator (0.0.3)                         8015     15547
            |factory_girl (3.6.0)                                    541   2042859
          EOS
        end
      end

      context 'with sort option: [a]download' do
        it "should display rubygems ordering by name" do
          capture(:stdout) { @executor.search('factory_girl', 'download') }.should == <<-'EOS'.unindent
            |NAME                                                DL(ver)   DL(all)
            |-------------------------------------------------- -------- ---------
            |factory_girl (3.6.0)                                    541   2042859
            |factory_girl_rails (3.5.0)                            39724   1238780
            |factory_girl_generator (0.0.3)                         8015     15547
          EOS
        end
      end
    end

    describe 'ruled NAME line' do
      context 'NAME size is 42' do
        before do
          stub_request(:get, build_search_uri('size_is_42_2345678901234567890123456789012')).
            to_return(:status => 200, :body => dummy_search_result_name_size_is_42)
        end
        it "should be 50 characters" do
          capture(:stdout) { @executor.search('size_is_42_2345678901234567890123456789012') }.should == <<-'EOS'.unindent
            |NAME                                                DL(ver)   DL(all)
            |-------------------------------------------------- -------- ---------
            |size_is_42_2345678901234567890123456789012 (0.0.1)      100      1000
          EOS
        end
      end

      context 'NAME size is 43' do
        before do
          stub_request(:get, build_search_uri('size_is_42_2345678901234567890123456789012')).
            to_return(:status => 200, :body => dummy_search_result_name_size_is_43)
        end
        it "should be 51 characters" do
          capture(:stdout) { @executor.search('size_is_42_2345678901234567890123456789012') }.should == <<-'EOS'.unindent
            |NAME                                                 DL(ver)   DL(all)
            |--------------------------------------------------- -------- ---------
            |size_is_43_23456789012345678901234567890123 (0.0.2)      200      2000
          EOS
        end
      end
    end
  end

  private
    def build_search_uri(query)
      "#{Gem::Search::Executor::SEARCH_URL}#{query}"
    end

    def dummy_search_result
      # top 3 gems searching with 'factory_girl'
      # https://rubygems.org/api/v1/search.json?query=factory_girl
      [{"name"=>"factory_girl",
        "downloads"=>2042859,
        "version"=>"3.6.0",
        "version_downloads"=>541,
        "platform"=>"ruby",
        "authors"=>"Josh Clayton, Joe Ferris",
        "info"=>
         "factory_girl provides a framework and DSL for defining and\n                      using factories - less error-prone, more explicit, and\n                      all-around easier to work with than fixtures.",
        "project_uri"=>"http://rubygems.org/gems/factory_girl",
        "gem_uri"=>"http://rubygems.org/gems/factory_girl-3.6.0.gem",
        "homepage_uri"=>"https://github.com/thoughtbot/factory_girl",
        "wiki_uri"=>"",
        "documentation_uri"=>"",
        "mailing_list_uri"=>"",
        "source_code_uri"=>"https://github.com/thoughtbot/factory_girl",
        "bug_tracker_uri"=>"",
        "dependencies"=>
         {"development"=>
           [{"name"=>"appraisal", "requirements"=>"~> 0.4"},
            {"name"=>"aruba", "requirements"=>">= 0"},
            {"name"=>"bourne", "requirements"=>">= 0"},
            {"name"=>"cucumber", "requirements"=>"~> 1.1"},
            {"name"=>"mocha", "requirements"=>">= 0"},
            {"name"=>"rspec", "requirements"=>"~> 2.0"},
            {"name"=>"simplecov", "requirements"=>">= 0"},
            {"name"=>"sqlite3-ruby", "requirements"=>">= 0"},
            {"name"=>"timecop", "requirements"=>">= 0"},
            {"name"=>"yard", "requirements"=>">= 0"}],
          "runtime"=>[{"name"=>"activesupport", "requirements"=>">= 3.0.0"}]}},
       {"name"=>"factory_girl_rails",
        "downloads"=>1238780,
        "version"=>"3.5.0",
        "version_downloads"=>39724,
        "platform"=>"ruby",
        "authors"=>"Joe Ferris",
        "info"=>
         "factory_girl_rails provides integration between\n    factory_girl and rails 3 (currently just automatic factory definition\n    loading)",
        "project_uri"=>"http://rubygems.org/gems/factory_girl_rails",
        "gem_uri"=>"http://rubygems.org/gems/factory_girl_rails-3.5.0.gem",
        "homepage_uri"=>"http://github.com/thoughtbot/factory_girl_rails",
        "wiki_uri"=>nil,
        "documentation_uri"=>nil,
        "mailing_list_uri"=>nil,
        "source_code_uri"=>nil,
        "bug_tracker_uri"=>nil,
        "dependencies"=>
         {"development"=>
           [{"name"=>"aruba", "requirements"=>">= 0"},
            {"name"=>"cucumber", "requirements"=>"~> 1.0.0"},
            {"name"=>"rails", "requirements"=>"= 3.0.7"},
            {"name"=>"rake", "requirements"=>">= 0"},
            {"name"=>"rspec", "requirements"=>"~> 2.6.0"}],
          "runtime"=>
           [{"name"=>"factory_girl", "requirements"=>"~> 3.5.0"},
            {"name"=>"railties", "requirements"=>">= 3.0.0"}]}},
       {"name"=>"factory_girl_generator",
        "downloads"=>15547,
        "version"=>"0.0.3",
        "version_downloads"=>8015,
        "platform"=>"ruby",
        "authors"=>"Les Hill",
        "info"=>"Rails 3 generator for factory_girl",
        "project_uri"=>"http://rubygems.org/gems/factory_girl_generator",
        "gem_uri"=>"http://rubygems.org/gems/factory_girl_generator-0.0.3.gem",
        "homepage_uri"=>"http://github.com/leshill/factory_girl_generator",
        "wiki_uri"=>nil,
        "documentation_uri"=>nil,
        "mailing_list_uri"=>nil,
        "source_code_uri"=>nil,
        "bug_tracker_uri"=>nil,
        "dependencies"=>{"development"=>[], "runtime"=>[]}}
      ].to_json
    end

    def dummy_search_result_name_size_is_42
      [{"name"=>"size_is_42_2345678901234567890123456789012",
        "downloads"=>1000,
        "version"=>"0.0.1",
        "version_downloads"=>100}
      ].to_json
    end

    def dummy_search_result_name_size_is_43
      [{"name"=>"size_is_43_23456789012345678901234567890123",
        "downloads"=>2000,
        "version"=>"0.0.2",
        "version_downloads"=>200}
      ].to_json
    end
end