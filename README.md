# lita-dig

[![Build Status](https://img.shields.io/travis/esigler/lita-dig/master.svg)](https://travis-ci.org/esigler/lita-dig)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://tldrlegal.com/license/mit-license)
[![RubyGems :: RMuh Gem Version](http://img.shields.io/gem/v/lita-dig.svg)](https://rubygems.org/gems/lita-dig)
[![Coveralls Coverage](https://img.shields.io/coveralls/esigler/lita-dig/master.svg)](https://coveralls.io/r/esigler/lita-dig)
[![Code Climate](https://img.shields.io/codeclimate/github/esigler/lita-dig.svg)](https://codeclimate.com/github/esigler/lita-dig)
[![Gemnasium](https://img.shields.io/gemnasium/esigler/lita-dig.svg)](https://gemnasium.com/esigler/lita-dig)

DNS record lookup [handler](https://github.com/jimmycuadra/lita).

## Installation

Add lita-dig to your Lita instance's Gemfile:

``` ruby
gem "lita-dig"
```

## Configuration

None

## Usage

Examples:

```
dig example.com              - Lookup the A record for example.com using the default resolver
dig example.com MX           - Lookup the MX record for example.com using the default resolver
```


## License

[MIT](http://opensource.org/licenses/MIT)
