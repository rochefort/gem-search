[![CircleCI](https://img.shields.io/circleci/project/rochefort/gem-search.svg)](https://circleci.com/gh/rochefort/gem-search)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/rochefort/gem-search)](https://codeclimate.com/github/rochefort/gem-search/maintainability)
[![Gem Version](http://img.shields.io/gem/v/gem-search.svg)](http://badge.fury.io/rb/gem-search)

# gem-search

`gem-search` is a command line utility like 'gem search'.  
You can see downloads total and sort columns.  

## Requirements

Ruby version >= 2.0.0.

## Installation

install it yourself as:

    $ gem install gem-search

## Usage

Use the gem-search as follows:


### Sorted by DL(all)

	gem-search `keyword'
	gem-search `keyword' -s a
	gem-search `keyword' -s all

e.g.:

```
$ gem-search webkit
NAME                                                DL(ver)   DL(all) HOMEPAGE
-------------------------------------------------- -------- --------- ------------------------------------------------------------
capybara-webkit (1.8.0)                               15324   2568161 http://github.com/thoughtbot/capybara-webkit
jasmine-headless-webkit (0.8.4)                      245135    323205
guard-jasmine-headless-webkit (0.3.2)                 70738     89705
rspec-formatter-webkit (2.6.0)                          355     23294 http://deveiate.org/webkit-rspec-formatter.html
webkit-gtk (3.0.7)                                      452     15734 http://ruby-gnome2.sourceforge.jp/
webkit-gtk2 (3.0.7)                                     487     12862 http://ruby-gnome2.sourceforge.jp/
webkit_remote (0.5.5)                                   866     12030 http://github.com/pwnall/webkit_remote
gtk-webkit-ruby (0.0.8)                                1644      8063 http://github.com/geoffyoungs/gtk-webkit-ruby
capybara-webkit-remote (0.0.4)                         1944      6968 http://github.com/pettyjamesm/capybara-webkit-remote
intentmedia-capybara-webkit (0.7.2.4)                  1796      6245 http://github.com/thoughtbot/capybara-webkit
gtk_webkit_pdf (0.0.2.2)                               1349      5934 https://github.com/mohanraj-ramanujam/gtk_webkit_pdf
webkit-rspec-formatter (2.0.2)                         2032      5099 http://deveiate.org/webkit-rspec-formatter.html
otherinbox-capybara-webkit (0.12.0.1)                  2924      4161 http://github.com/thoughtbot/capybara-webkit
jasmine-headless-webkit-firstbanco (0.9.0.rc.5)        2436      3995
webkit_remote_unstable (0.1.3)                          823      3233 http://github.com/pwnall/webkit_remote_unstable
webkit2-gtk (3.0.7)                                     421      2178 http://ruby-gnome2.sourceforge.jp/
bitium-capybara-webkit (1.1.1)                         1208      1208 http://github.com/thoughtbot/capybara-webkit
imseng-capybara-webkit (0.12.1)                        1199      1199 http://github.com/imseng/capybara-webkit
node-webkit-bootstrap (1.0.0)                           873       873 https://github.com/audiosocket/node-webkit-bootstrap```
```

### Sorted by gem name

	gem-search `keyword' -s n
	gem-search `keyword' -s name

e.g.:

```
$ gem-search webkit -s n
NAME                                                DL(ver)   DL(all) HOMEPAGE
-------------------------------------------------- -------- --------- ------------------------------------------------------------
bitium-capybara-webkit (1.1.1)                         1208      1208 http://github.com/thoughtbot/capybara-webkit
capybara-webkit (1.8.0)                               15324   2568161 http://github.com/thoughtbot/capybara-webkit
capybara-webkit-remote (0.0.4)                         1944      6968 http://github.com/pettyjamesm/capybara-webkit-remote
gtk-webkit-ruby (0.0.8)                                1644      8063 http://github.com/geoffyoungs/gtk-webkit-ruby
gtk_webkit_pdf (0.0.2.2)                               1349      5934 https://github.com/mohanraj-ramanujam/gtk_webkit_pdf
guard-jasmine-headless-webkit (0.3.2)                 70738     89705
imseng-capybara-webkit (0.12.1)                        1199      1199 http://github.com/imseng/capybara-webkit
intentmedia-capybara-webkit (0.7.2.4)                  1796      6245 http://github.com/thoughtbot/capybara-webkit
...
```

### Sorted by DL(ver)

	gem-search `keyword' -s v
	gem-search `keyword' -s ver
	gem-search `keyword' -s version

e.g.:

```
$ gem-search webkit -s v
NAME                                                DL(ver)   DL(all) HOMEPAGE
-------------------------------------------------- -------- --------- ------------------------------------------------------------
jasmine-headless-webkit (0.8.4)                      245135    323205
guard-jasmine-headless-webkit (0.3.2)                 70738     89705
capybara-webkit (1.8.0)                               15324   2568162 http://github.com/thoughtbot/capybara-webkit
otherinbox-capybara-webkit (0.12.0.1)                  2924      4161 http://github.com/thoughtbot/capybara-webkit
jasmine-headless-webkit-firstbanco (0.9.0.rc.5)        2436      3995
webkit-rspec-formatter (2.0.2)                         2032      5099 http://deveiate.org/webkit-rspec-formatter.html
capybara-webkit-remote (0.0.4)                         1944      6968 http://github.com/pettyjamesm/capybara-webkit-remote
intentmedia-capybara-webkit (0.7.2.4)                  1796      6245 http://github.com/thoughtbot/capybara-webkit
...
```

### Use exact match

	gem-search -e `keyword'

e.g.:
```
$ gem-search -e rails
Searching .
NAME                                                DL(ver)   DL(all) HOMEPAGE
-------------------------------------------------- -------- --------- ------------------------------------------------------------
rails (5.0.2)                                        605263  93503475 http://rubyonrails.org
```


### Do not show Homepage URL
	gem-search `keyword' --no-homepage

e.g.:
```
$ gem-search webkit -d
NAME                                                DL(ver)   DL(all)
-------------------------------------------------- -------- ---------
capybara-webkit (1.8.0)                               15325   2568165
jasmine-headless-webkit (0.8.4)                      245135    323210
guard-jasmine-headless-webkit (0.3.2)                 70738     89707
rspec-formatter-webkit (2.6.0)                          355     23294
webkit-gtk (3.0.7)                                      452     15734
webkit-gtk2 (3.0.7)                                     487     12862
webkit_remote (0.5.5)                                   866     12030
gtk-webkit-ruby (0.0.8)                                1644      8063
...
```

### Browse
It open rubygem's homepage in the system's default web browser.

    gem-search -b `keyword'
    gem-search --browse `keyword'


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
