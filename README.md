[![CircleCI](https://img.shields.io/circleci/project/rochefort/gem-search.svg?style=flat)](https://circleci.com/gh/rochefort/gem-search)
[![Dependency Status](http://img.shields.io/gemnasium/rochefort/gem-search.svg?style=flat)](https://gemnasium.com/rochefort/gem-search)
[![Code Climate](http://img.shields.io/codeclimate/github/rochefort/gem-search.svg?style=flat)](https://codeclimate.com/github/rochefort/gem-search)
[![Gem Version](http://img.shields.io/gem/v/gem-search.svg?style=flat)](http://badge.fury.io/rb/gem-search)

# gem-search

Now gem-search is not published as a rubygem.  
gem-search is a command line utitlity like rubygems('gem search').  
You can see a download total gem and sort columns.

## Requirements

Ruby version >= 2.0.0.

## Installation

install it yourself as:

    $ gem install gem-search

## Usage

Use the gem-search as follows:


### Sorted by DL(all)

	gem-search `keyword'
	or
	gem-search `keyword' -s a

e.g.:

```
$ gem-search webkit
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

### Sorted by gem name
	gem-search `keyword' -s n

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

### Display Homepage URL
	gem-search `keyword' -d
	
	or
	
	gem-search `keyword' --detail

e.g.:
```
$ gem-search webkit -d
NAME                                                DL(ver)   DL(all) HOMEPAGE
-------------------------------------------------- -------- --------- ------------------------------------------------------------
capybara-webkit (1.2.0)                               11691   1291179 http://github.com/thoughtbot/capybara-webkit
jasmine-headless-webkit (0.8.4)                      213767    273893
guard-jasmine-headless-webkit (0.3.2)                 66446     80976
rspec-formatter-webkit (2.4.0)                         1532     14984 http://deveiate.org/webkit-rspec-formatter.html
webkit_remote (0.5.5)                                   224      6111 http://github.com/pwnall/webkit_remote
webkit-gtk (2.2.0)                                      297      5571 http://ruby-gnome2.sourceforge.jp/
gtk-webkit-ruby (0.0.8)                                 716      4585 http://github.com/geoffyoungs/gtk-webkit-ruby
capybara-webkit-remote (0.0.4)                         1206      4450 http://github.com/pettyjamesm/capybara-webkit-remote
intentmedia-capybara-webkit (0.7.2.4)                  1155      4208 http://github.com/thoughtbot/capybara-webkit
webkit-gtk2 (2.2.0)                                     282      3976 http://ruby-gnome2.sourceforge.jp/
webkit-rspec-formatter (2.0.2)                         1417      3614 http://deveiate.org/webkit-rspec-formatter.html
gtk_webkit_pdf (0.0.2.2)                                698      3314 https://github.com/mohanraj-ramanujam/gtk_webkit_pdf
otherinbox-capybara-webkit (0.12.0.1)                  2343      3145 http://github.com/thoughtbot/capybara-webkit
jasmine-headless-webkit-firstbanco (0.9.0.rc.4)         179      1591
webkit_remote_unstable (0.1.3)                          222      1295 http://github.com/pwnall/webkit_remote_unstable
imseng-capybara-webkit (0.12.1)                         549       549 http://github.com/imseng/capybara-webkit
bitium-capybara-webkit (1.1.1)                          388       388 http://github.com/thoughtbot/capybara-webkit
node-webkit-bootstrap (1.0.0)                           226       226 https://github.com/audiosocket/node-webkit-bootstrap
```

### Browse
It open rubygem's homepage in the system's default web browser.

    gem-search -b `keyword'
    
    or
    
    gem-search --browse `keyword'


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
