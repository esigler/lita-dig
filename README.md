# lita-dig

[![Build Status](https://img.shields.io/travis/esigler/lita-dig/master.svg)](https://travis-ci.org/esigler/lita-dig)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://tldrlegal.com/license/mit-license)
[![RubyGems](http://img.shields.io/gem/v/lita-dig.svg)](https://rubygems.org/gems/lita-dig)
[![Code Climate](https://img.shields.io/codeclimate/github/esigler/lita-dig.svg)](https://codeclimate.com/github/esigler/lita-dig)
[![Gemnasium](https://img.shields.io/gemnasium/esigler/lita-dig.svg)](https://gemnasium.com/esigler/lita-dig)

A DNS record lookup plugin for [Lita](https://github.com/jimmycuadra/lita).

## Installation

Add lita-dig to your Lita instance's Gemfile:

``` ruby
gem "lita-dig"
```

## Configuration

Configuring the default resolver is optional. If nothing specifed, 8.8.8.8 is used.

```
config.handlers.dig.default_resolver = '127.0.0.1'
```

## Usage

Examples:

```
dig example.com [+short]          - Lookup the A record for example.com using the default resolver (optionally just IP addressses)
dig example.com MX                - Lookup the MX record for example.com using the default resolver
dig @8.8.8.8 example.com [+short] - Lookup the A record for example.com using 8.8.8.8 as a resolver (optionally just IP addressses)
dig @8.8.8.8 example.com NS       - Lookup the NS record for example.com using 8.8.8.8 as a resolver
```

The majority of DNS record types (including "any") are supported.

## License

[MIT](http://opensource.org/licenses/MIT)
