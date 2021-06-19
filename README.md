[![CircleCI](https://circleci.com/gh/kvokka/dtn.svg?style=svg&circle-token=ed32de8a1360f1100f4601ee6d7311fd2b310220)](https://circleci.com/gh/kvokka/dtn)
[![Gem Version](https://img.shields.io/gem/v/dtn.svg)](https://rubygems.org/gems/dtn)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)
[![Maintainability](https://api.codeclimate.com/v1/badges/7bf62332c4d163460678/maintainability)](https://codeclimate.com/github/kvokka/dtn/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7bf62332c4d163460678/test_coverage)](https://codeclimate.com/github/kvokka/dtn/test_coverage)

# Dtn

Unofficial DTN (IQFeed) client.

# Dependencies

* IQFeed client ~> 6.1

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dtn'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dtn

## Usage

### Quick start

```ruby
Dtn::Requests::Historical::DailyTimeframe.call(
    symbol: :aapl,
    begin_date: Date.new(2021, 05, 01),
    end_date: Date.new(2021, 06, 01)
    )

=>
#<Dtn::Messages::Historical::DailyWeeklyMonthly request_id=1, timestamp=Mon, 03 May 2021 18:06:37 +0000, high=134.07, low=131.83, open=132.04, close=132.54, period_volume=75135100, open_interest=0>
#<Dtn::Messages::Historical::DailyWeeklyMonthly request_id=1, timestamp=Tue, 04 May 2021 18:06:37 +0000, high=131.4899, low=126.7, open=131.19, close=127.85, period_volume=137564718, open_interest=0>
#<Dtn::Messages::Historical::DailyWeeklyMonthly request_id=1, timestamp=Wed, 05 May 2021 18:06:37 +0000, high=130.45, low=127.97, open=129.2, close=128.1, period_volume=84000900, open_interest=0>
#<Dtn::Messages::Historical::DailyWeeklyMonthly request_id=1, timestamp=Thu, 06 May 2021 18:06:37 +0000, high=129.75, low=127.13, open=127.89, close=129.74, period_volume=78128334, open_interest=0>
...

# if block provided, then each message will be yielded as it is processed

Dtn::Requests::News::Headline.call(limit: 10) do |message|
  # ...
end
```

### Supported requests

#### News

* [config](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/news/config.rb)
```ruby
Dtn::Requests::News::Config.call
```
* [headline](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/news/headline.rb)
```ruby
Dtn::Requests::News::Headline.call limit: 10, symbols: 'aapl;fb'
```
* [story_count](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/news/story_count.rb)
```ruby
Dtn::Requests::News::StoryCount.call symbols: :aapl, date_range: Date.new(2020,1,1)..Date.new(2020,2,1)
```
* [story](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/news/story.rb)
```ruby
Dtn::Requests::News::Story.call story_id: '22424363689'
```


NOTES:

* if XML output option selected, the response will return **unparsed** XML

#### Historical

* [interval_day](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/interval_day.rb)
```ruby
Dtn::Requests::Historical::IntervalDay.call(symbol: :aapl, interval: 3600, max_datapoints: 50, days: 2)
```
* [tick_timeframe](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/tick_timeframe.rb)
```ruby
Dtn::Requests::Historical::TickTimeframe.call(
              symbol: :aapl,
              begin_datetime: begin_datetime,
              end_datetime: end_datetime,
              max_datapoints: 50
            )
```
* [daily_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/daily_datapoint.rb)
```ruby
Dtn::Requests::Historical::DailyDatapoint.call(symbol: :aapl, max_datapoints: 50)
```
* [interval_timeframe](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/interval_timeframe.rb)
```ruby
Dtn::Requests::Historical::IntervalTimeframe.call(
              symbol: :aapl,
              interval: 15,
              max_datapoints: 50,
              begin_datetime: DateTime.new(2020,05,01),
              end_datetime: DateTime.new(2020,06,01)
            )
```
* [tick_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/tick_datapoint.rb)
```ruby
Dtn::Requests::Historical::TickDatapoint.call(symbol: :aapl, max_datapoints: 100)
```
* [weekly_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/weekly_datapoint.rb)
```ruby
Dtn::Requests::Historical::WeeklyDatapoint.call(symbol: :aapl, max_datapoints: 10)
```
* [daily_timeframe](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/daily_timeframe.rb)
```ruby
Dtn::Requests::Historical::DailyTimeframe.call(
              symbol: :aapl,
              begin_date: Date.new(2020,05,01),
              end_date: Date.new(2020,06,01)
            )
```
* [interval_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/interval_datapoint.rb)
```ruby
Dtn::Requests::Historical::IntervalDatapoint.call(symbol: :aapl, interval: 3600, max_datapoints: 100)
```
* [monthly_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/monthly_datapoint.rb)
```ruby
Dtn::Requests::Historical::MonthlyDatapoint.call(symbol: :aapl, max_datapoints: 10)
```
* [tick_day](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/tick_day.rb)
```ruby
Dtn::Requests::Historical::TickDay.call(symbol: :aapl, days: 2, max_datapoints: 50)
```

NOTES:

* Requests have extra options from their parents classes. They have appropriate
defaults and are easy to customize.

#### Catalogs

For symbol lookup and description API use a few catalogs, which describe each row.
They very rarely change and we can treat them as constants. To reduce requests to
API they are requested only once. For easy access to them you can use:

* `Dtn.listed_markets_catalog`
* `Dtn.naic_codes_catalog`
* `Dtn.security_types_catalog`
* `Dtn.sic_codes_catalog`
* `Dtn.trade_conditions_catalog`

#### Symbol lookup

* [by_sic](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/symbol/by_sic.rb)
```ruby
Dtn::Requests::Symbol::BySic.call(search_line: '42')
```
* [by_naic](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/symbol/by_naic.rb)
```ruby
Dtn::Requests::Symbol::ByNaic.call(search_line: '42')
```
* [by_filter](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/symbol/by_filter.rb)
```ruby
Dtn::Requests::Symbol::ByFilter.call(field_to_search: "s", search_line: "aap", filter_type: "t", filter_value: "1")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bundle exec rake` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

Test specs are using recorded output from DTN client. The recorded file is set
by the RSpec option `socket_recorder`, so you can share 1 recording with a few
specs. If the file is missing, then specs will do real request to the api.
`socket_recorder` will use the pre-defined Date for the specs from the file
[current_day](https://github.com/kvokka/dtn/blob/master/spec/current_day) to
minimise recordings rewrites. To bump the date to the yesterday business day
you can use

```bash
$ bundle exec rake spec:set_spec_date
```

To run the client you can use the `docker-compose up` (before execution pls fill
in `.env` file with your credentials following the pattern from
[.env.example](https://github.com/kvokka/dtn/blob/master/.env.example))

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kvokka/dtn. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/kvokka/dtn/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dtn project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kvokka/dtn/blob/master/CODE_OF_CONDUCT.md).
