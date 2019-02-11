# DateHolidays::Reader

[![Build Status](https://travis-ci.org/bluemarblepayroll/date_holidays-reader.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/date_holidays-reader)

This is a read-only Ruby wrapper for the
[date-holidays](https://github.com/commenthol/date-holidays) Node module. Note that Node does not have to be installed on many machines in order to use this gem. See the configuration section for more details.

## Usage

Holiday information is available for many different locales. The first step is to create a locale object which represents a country or part of a country. For example, to retrieve all holidays for this year in the United States:

```ruby
us = DateHolidays::Reader::Locale.new(country: :us)
us.holidays(Date.today.year) # returns a list of US holidays for the current year
```

Locales can be refined to just one state or even a region within a state:

```ruby
louisiana = DateHolidays::Reader::Locale.new(country: :us, state: :la)
louisiana.holidays(Date.today.year) # returns US and Louisiana holidays

new_orleans = DateHolidays::Reader::Locale.new(country: :us, state: :la, region: :no)
new_orleans.holidays(Date.today.year) # includes Mardi Gras plus all state country holidays
```

### Languages

Some countries support more than one language:

```ruby
mx = DateHolidays::Reader::Locale.new(country: :mx)
mx.languages # ["en", "es"]
mx.holidays(Date.year)
mx.holidays(Date.today.year).first.name                # "New Year's Day"
mx.holidays(Date.today.year, language: :es).first.name # "Año Nuevo"
```

### Meta Data

Country, state, and region codes are defined in the [ISO 3166-2 standard](https://en.wikipedia.org/wiki/ISO_3166-2). These examples pass in the codes using Ruby symbols. However, it is also valid to specify them as Ruby strings. The supported codes can also be retrived using the following meta-data methods:

```ruby
# Returns a hash of all supported countries keyed by two letter ISO 3166-2 code
# and values of the country name:
DateHolidays::Reader::Config.countries
# {"AD"=>"Andorra", "AE"=>"دولة الإمارات العربية المتحدة", ... }

# Returns a hash of all supported states keyed by two letter ISO 3166-2 code
# and values of the state name:
DateHolidays::Reader::Locale.new(country: :us).states
# {"AL"=>"Alabama", "AK"=>"Alaska", "AZ"=>"Arizona", ... }

# Returns a hash of all supported regions keyed by two letter ISO 3166-2 code
# and values of the region name:
DateHolidays::Reader::Locale.new(country: :us, state: :la).regions
# {"NO"=>"New Orleans"}
```

### Holiday Object

`DateHolidays::Reader::Locale#holidays` returns a list containing an instance of `DateHolidays::Reader::Holiday` objects which have the following fields:

* *date* - The start date of the holiday which is stored in a Ruby `Date` instance.
* *start_time* - The start time of the holiday in UTC represented as a `Time` instance. Note that these times represent when the holiday starts *in this locale*. For example, US New Year's day in 2019 has a time of '2019-01-01 05:00:00 UTC' as Washington DC is five hours behind UTC.
* *end_time* - The time in UTC when the holiday ends. Note that some holidays (for example certain religious holidays) may not start or end on midnight. Also, some holidays last more or less then 24 hours.
* *name* - A string representing the human readable name of the holiday. For example: "New Year's Day."
* *type* - A symbol which describes the status of the holiday. See the [date-holidays documentation](https://github.com/commenthol/date-holidays#types-of-holidays) for a full explanation.
* *substitute* - A boolean value that, if true, means that it is a substitute for another holiday.
* *note* - An optional human readable note represented as a `String` or `nil`.

Note that this is a wrapper for the JavaScript Holiday object described [here](https://github.com/commenthol/date-holidays#types-of-holidays).

### API Comparison

The API provided by this gem is somewhat different than the [API provided by the date-holidays node module](https://github.com/commenthol/date-holidays-parser/blob/master/docs/Holidays.md). This is intentional in order to make the Ruby API more object-oriented. The biggest change is that the JavaScript API does not have a locale class.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'date_holidays-reader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install date_holidays-reader

If you are running a Linux or Mac OS X machine running an [x86-64](https://en.wikipedia.org/wiki/X86-64) compatible processor then everything should work at this point. If you are running a different OS, different processor, or would like to use Node directly then continue to the configuration section.

## Configuration

This gem ships with pre-compiled wrapper programs for the date-holidays Node module for Mac OS X and Linux running on [x86-64](https://en.wikipedia.org/wiki/X86-64) processors. If you are running on those architectures then no configuration is needed as one those binaries will be used by default. If the gem detects that you are running on a different architecture then it will attempt to use the version of Node.js in your path. In this case, you will need to install the [date-holidays Node module](https://github.com/commenthol/date-holidays) before using this gem. It is also possible to explicitly tell the gem where your Node.js binary is located:

```ruby
  DateHolidays::Reader::Config.node_path = '/path/to/your/version/of/node'
```

Note that setting `node_path` will also force the gem to use Node instead of the provided binaries when running on a supported OS and processor combination.

Note that native Windows support would not be difficult to add. Pull requests are welcome!

## Related Work

The [holidays](https://github.com/holidays/holidays) gem is very similar and is a pure Ruby implementation. This gem was created as the date-holidays node module has support for more countries. An advantage of the holidays gem over this gem is that holidays is faster as it does not have to fork a Node.js process in order to retrieve data. Also, the holidays gem has support for some niche data such as [US Federal Reserve Banks](https://github.com/holidays/definitions/blob/master/federalreservebanks.yaml), the [New York Stock Exchange](https://github.com/holidays/definitions/blob/master/nyse.yaml), and others. Use the right tool for your needs.

## Future Direction

The holiday definitions provided by the date-holidays Node module are defined by a specific grammar housed in YAML files. The next logical step would be to build a pure Ruby parser for this grammar. Time is the only limit here. If this work is done, it would be in a separate gem as it would not have to be a read-only interface; it would be trivial to support user defined holiday definitions like the Node module.

## Gem Name

You may be wondering: "Why the underscore and dash in the name?" This is intentional to match the name of of the main Ruby module of `DateHolidays::Reader`. The Ruby convention is to use underscores to separate words and dashes for namespaces. Note that if another gem is created which is not just a Node module wrapper then the module will be just `DateHolidays` and the gem will be named date_holidays.

## Development

Since this gem wraps a Node module, a Node.js installation is required. See the `.nvmrc` file for a recommended Node version. [Yarn](https://yarnpkg.com/lang/en/docs/install/) is also required to install requisite Node modules.

After checking out the repo and installing Node and Yarn, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

Note that `rake clobber` can be used to removed the pre-compiled Node wrappers.

There is also a `Dockerfile` provided which can be used to verify the Linux binaries.

### Releasing

1. Update the version number in `version.rb` and add a new entry to `CHANGELOG.md`.

1. Then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Updating the date-holidays Node Module Dependency

1. Update node modules:

```bash
yarn upgrade
```

Verify from the Yarn output that date-holidays was updated.

2. Recompile the node-bin binaries:

```bash
bundle exec rake node_compile
```

3. Update the node module version in `spec/date_holidays/reader/version_spec.rb`.

4. Verify by running the tests and check in yarn.lock.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bluemarblepayroll/date_holidays-reader. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Before submitting a pull requests, please do the following:

1. Update the README.md if changing or adding to the API.
2. Add to or update unit tests.
3. Ensure that all tests are passing.
4. Ensure that rubocop does not find any issues.

## Code of Conduct

Everyone interacting in the DateHolidays::Reader project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bluemarblepayroll/date_holidays-reader/blob/master/CODE_OF_CONDUCT.md).

## License

This project is MIT and [Creative Commons Attribution-ShareAlike 3.0](http://creativecommons.org/licenses/by-sa/3.0/)
Licensed. See the LICENSE file for more information.

## TODO

* Holiday type filtering should be handled by Node.
