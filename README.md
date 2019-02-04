# DateHolidays::Reader

This is a read only Ruby wrapper for the
[date-holidays](https://github.com/commenthol/date-holidays) Node module. Note that Node does not have to be installed on many machines in order to use this gem. See the configuration section for more details.

## Usage

TODO: Write usage instructions here.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'date_holidays-reader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install date_holidays-reader

If you are runnning a Linux or Mac OS X machine running a 64 x86 compatible processor then everything should work at this point. If you are running a different OS, different processor, or would like to use Node directly then continue to the configuration section.

e

## Configuration

This gem ships with pre-compiled wrapper programs for the date-holidays node module for Mac OS X and Linux running on 64 bit x86 processors. If you are running on those architectures then no configuration is needed as one those binaries will be used by default. If the gem detects that you are running on a different architecture then it will attempt to use the version of Node.js in your path. In this case, you will need to install the [date-holidays Node module](https://github.com/commenthol/date-holidays) before using this gem. It is also possible to explicitly tell the gem where your Node.js binary is located:

```ruby
  DateHolidays::Reader::Config.node_path = '/path/to/your/version/of/node`
```

Note that setting `node_path` will also force the gem to use Node instead of the provided binaries when running on a supported OS and processor combination.

Note that native Windows support would not be difficult to add. Pull requests are welcome!

## Related Work

The [holidays](https://github.com/holidays/holidays) gem is very similar and is a pure Ruby implimentaiton. This gem was created as the date-holidays node module has support for more countries. An advantages of the holidays gem over this gem is that holidays is faster as it does not have to fork a Node.js process in order to retreive data. Also, the holidays gem has support for some niche data such as [US Federal Reserve Banks](https://github.com/holidays/definitions/blob/master/federalreservebanks.yaml), the [New York Stock Exchange](https://github.com/holidays/definitions/blob/master/nyse.yaml), and others. Use the right tool for your needs.

## Future Direction

The holiday definitions provided by the date-holidays Node module defined by a specific grammer housed in YAML files. The next logical step would be to build a pure Ruby parser for this grammar. Time is the only limit here. If this works is done, it would be in a separate gem as it would not have to be a read only interface; it would be trivial to support user defined holiday definitions like the Node module.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Releasing

1. Update the version number in `version.rb` and add a new entry to `CHANGELOG.md`.

1. Then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Updating the date-holidays Node Module Dependency

1. Update node modules:

```bash
$ yarn upgrade
```

Verify from the Yarn output that date-holidays was updated.

2. Recompile the node-bin binaries:

```bash
bundle exec rake node_compile
```

3. Update the node module version in `spec/date_holidays/reader/version_spec.rb`.

4. Verify by running the tests and check in yarn.lock.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/date_holidays-reader. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the DateHolidays::Reader project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/date_holidays-reader/blob/master/CODE_OF_CONDUCT.md).

## TODO

* Holiday type filtering should be handled by node.
