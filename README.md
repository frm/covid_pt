# COVID PT

A gem to get the COVID-19 data for Portugal.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'covid_pt'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install covid_pt

## Usage

There are 3 main functions to generate a report.

```ruby
report = CovidPT.report("2020-07-01")
# Generates the report for the given date

report = CovidPT.between("2020-07-01", "2020-07-02")
# Compare the two dates directly

report = CovidPT.range("2020-07-01", "2020-07-05")
# Compare every date between the two given dates

# Printing a given report in different formats:

# Printing in TXT format
CovidPT::Printer.pp(report)

# Printing in Markdown format
CovidPT::Printer.md(report)

# Printing in JSON
CovidPT::Printer.json(report)
```

There is also a command line tool available:

```shell
$ covid_pt --date="2020-07-01" --output=md
$ covid_pt --between="2020-07-01,2020-07-02" --output=json
$ covid_pt --range="2020-07-01,2020-07-10"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/frm/covid_pt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/frm/covid_pt/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CovidPT project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/frm/covid_pt/blob/master/CODE_OF_CONDUCT.md).
