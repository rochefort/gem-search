[![Build Status](http://img.shields.io/travis/rochefort/gem-search.svg?style=flat)](http://travis-ci.org/rochefort/gem-search)
[![Dependency Status](http://img.shields.io/gemnasium/rochefort/gem-search.svg?style=flat)](https://gemnasium.com/rochefort/gem-search)
[![Code Climate](http://img.shields.io/codeclimate/github/rochefort/gem-search.svg?style=flat)](https://codeclimate.com/github/rochefort/gem-search)
[![Gem Version](http://img.shields.io/gem/v/gem-search.svg?style=flat)](http://badge.fury.io/rb/gem-search)

# gem-search

gem-search is a command line utitlity like rubygems('gem search').  
You can see a download total gem and sort columns.


## Installation

install it yourself as:

    $ gem install gem-search

## Usage

Use the gem-search as follows:

### Sorted by gem name
	gem-search `keyword'

e.g.:

```
$ gem-search webkit
NAME                                                DL(ver)   DL(all)
-------------------------------------------------- -------- ---------
capybara-webkit (0.12.1)                              24863    185214
capybara-webkit-remote (0.0.4)                          209       838
gtk-webkit-ruby (0.0.3)                                 289       289
guard-jasmine-headless-webkit (0.3.2)                 11964     17872
intentmedia-capybara-webkit (0.7.2.4)                   370      1362
jasmine-headless-webkit (0.8.4)                       19444     46147
otherinbox-capybara-webkit (0.12.0.1)                   594       740
rspec-formatter-webkit (2.2.0)                          438      3549
webkit-rspec-formatter (2.0.2)                          613      1573
```

### Sorted by DL(ver)
	gem-search `keyword' -s v

e.g.:

```
$ gem-search webkit -s v
NAME                                                DL(ver)   DL(all)
-------------------------------------------------- -------- ---------
capybara-webkit (0.12.1)                              24863    185214
jasmine-headless-webkit (0.8.4)                       19444     46147
guard-jasmine-headless-webkit (0.3.2)                 11964     17872
webkit-rspec-formatter (2.0.2)                          613      1573
otherinbox-capybara-webkit (0.12.0.1)                   594       740
rspec-formatter-webkit (2.2.0)                          438      3549
intentmedia-capybara-webkit (0.7.2.4)                   370      1362
gtk-webkit-ruby (0.0.3)                                 289       289
capybara-webkit-remote (0.0.4)                          209       838
```

### Sorted by DL(all)

	gem-search `keyword' -s a

e.g.:

```
$ gem-search webkit -s a
NAME                                                DL(ver)   DL(all)
-------------------------------------------------- -------- ---------
capybara-webkit (0.12.1)                              24863    185214
jasmine-headless-webkit (0.8.4)                       19444     46147
guard-jasmine-headless-webkit (0.3.2)                 11964     17872
rspec-formatter-webkit (2.2.0)                          438      3549
webkit-rspec-formatter (2.0.2)                          613      1573
intentmedia-capybara-webkit (0.7.2.4)                   370      1362
capybara-webkit-remote (0.0.4)                          209       838
otherinbox-capybara-webkit (0.12.0.1)                   594       740
gtk-webkit-ruby (0.0.3)                                 289       289
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
