## v0.3.2
- Fix return all search results refs:608d1c5

## v0.3.1
- Fix gem.executables refs:b7c9c6d

## v0.3.0
- Add exact option  
use exact matching when specified `exact` option.
- Update gems

## v0.2.2
- Refactor

## v0.2.1
- Update gems [88da69c]

## v0.2.0
- Update gems [d6b6c89]

## v0.2.0

- Add a Interrupt handling [a93beb1]  
When it detect Interrupt(Ctrl-C), it display results of searching part way through.

## v0.1.9

- Show homepage url as default option [ddae051]  
Add a `no-homepage` option not to show homepage url.  

## v0.1.8

- Add variations of sort [9aed9e4]  
variations: a/all/, n/name, v/ver/version
(not case-sensitive)

## v0.1.7

- Remove redundancy dots [54c34af]  
The request was one extra.

## v0.1.6

- Update gems [17ae8cd]  
- Refactor tests  

## v0.1.5

- Update slop for v4.0.0 and refactor. [94db668]  
unsupported Ruby 1.9.0

## v0.1.4

- Fix cannot open gem url when gem has no homepage url. [b476b28]

## v0.1.3

- Implement a feature that is shown a homepage url when detail option is selected [f89d9c2]

## v0.1.2

- Correspond to linux with browse option [80bb881]
- Implement a feature that is to open homepage url by a default browser. [49d2924]

## v0.1.1

- Change default sort option from n[ame] to do a[ll] (download) [7041464]
- Fix default sort option doesn't work. [e404c6e]
- Fix proxy doesn't work by not using authentication [210ea37]
