[![CircleCI](https://circleci.com/gh/kvokka/dtn.svg?style=svg&circle-token=ed32de8a1360f1100f4601ee6d7311fd2b310220)](https://circleci.com/gh/kvokka/dtn)
[![Gem Version](https://img.shields.io/gem/v/dtn.svg)](https://rubygems.org/gems/dtn)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)
[![Maintainability](https://api.codeclimate.com/v1/badges/7bf62332c4d163460678/maintainability)](https://codeclimate.com/github/kvokka/dtn/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7bf62332c4d163460678/test_coverage)](https://codeclimate.com/github/kvokka/dtn/test_coverage)

# Dtn

Unofficial DTN (IQFeed) client.

All requests and responses are async and Thread safe.

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
client = Dtn::Clients::Lookup.new
client.request.historical.daily_timeframe(
    symbol: :aapl,
    begin_date: Date.new(2021, 05, 01),
    end_date: Date.new(2021, 06, 01)
    )

client.response.each { |message| puts message }

=>
#<Dtn::Messages::DailyWeeklyMonthly request_id=1, timestamp=Mon, 03 May 2021 18:06:37 +0000, high=134.07, low=131.83, open=132.04, close=132.54, period_volume=75135100, open_interest=0>
#<Dtn::Messages::DailyWeeklyMonthly request_id=1, timestamp=Tue, 04 May 2021 18:06:37 +0000, high=131.4899, low=126.7, open=131.19, close=127.85, period_volume=137564718, open_interest=0>
#<Dtn::Messages::DailyWeeklyMonthly request_id=1, timestamp=Wed, 05 May 2021 18:06:37 +0000, high=130.45, low=127.97, open=129.2, close=128.1, period_volume=84000900, open_interest=0>
#<Dtn::Messages::DailyWeeklyMonthly request_id=1, timestamp=Thu, 06 May 2021 18:06:37 +0000, high=129.75, low=127.13, open=127.89, close=129.74, period_volume=78128334, open_interest=0>
...
```

### Supported requests

#### News

For all requests `client = Dtn::Clients::Lookup.new` was used

* [config](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/news/config.rb)
```ruby
client.request.news.config
```
* [headline](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/news/headline.rb)
```ruby
client.request.news.headline limit: 10, symbols: 'aapl;fb'
```

NOTES:

* if XML output option selected, the response will return **unparsed** XML

#### Historical

For all requests `client = Dtn::Clients::Lookup.new` was used

* [interval_day](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/interval_day.rb)
```ruby
client.request.historical.interval_day(symbol: :aapl, interval: 3600, max_datapoints: 50, days: 2)
```
* [tick_timeframe](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/tick_timeframe.rb)
```ruby
client.request.historical.tick_timeframe(
              symbol: :aapl,
              begin_datetime: begin_datetime,
              end_datetime: end_datetime,
              max_datapoints: 50
            )
```
* [daily_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/daily_datapoint.rb)
```ruby
client.request.historical.daily_datapoint(symbol: :aapl, max_datapoints: 50)
```
* [interval_timeframe](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/interval_timeframe.rb)
```ruby
client.request.historical.interval_timeframe(
              symbol: :aapl,
              interval: 15,
              max_datapoints: 50,
              begin_datetime: DateTime.new(2020,05,01),
              end_datetime: DateTime.new(2020,06,01)
            )
```
* [tick_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/tick_datapoint.rb)
```ruby
client.request.historical.tick_datapoint(symbol: :aapl, max_datapoints: 100)
```
* [weekly_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/weekly_datapoint.rb)
```ruby
client.request.historical.weekly_datapoint(symbol: :aapl, max_datapoints: 10)
```
* [daily_timeframe](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/daily_timeframe.rb)
```ruby
client.request.historical.daily_timeframe(
              symbol: :aapl,
              begin_date: Date.new(2020,05,01),
              end_date: Date.new(2020,06,01)
            )
```
* [interval_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/interval_datapoint.rb)
```ruby
client.request.historical.interval_datapoint(symbol: :aapl, interval: 3600, max_datapoints: 100)
```
* [monthly_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/monthly_datapoint.rb)
```ruby
client.request.historical.monthly_datapoint(symbol: :aapl, max_datapoints: 10)
```
* [tick_day](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/tick_day.rb)
```ruby
client.request.historical.tick_day(symbol: :aapl, days: 2, max_datapoints: 50)
```

NOTES:

* Requests have extra options from their parents classes. They have appropriate
defaults and are easy to customize.

## Fetching responses

Responses are stored in the queue, so you can access to each of them only once.
It is done by design and this allows to make this gem to work fast. Keep this in
mind when you receiving your data.

By default it is assumed, that you run 1 request on 1 client, because it simplify
the underlying socket management. After the request if done client stop.
There is a workaround of this in [Advanced Usage](#advanced-usage) section

## Advanced usage

### Running multiple requests on one client

```ruby
client = Dtn::Clients::Lookup.new auto_stop: false

client.request.historical.interval_datapoint(symbol: :aapl, interval: 3600, max_datapoints: 3)
client.request.historical.interval_datapoint(symbol: :fb, interval: 3600, max_datapoints: 3)
client.request.historical.interval_datapoint(symbol: :msft, interval: 3600, max_datapoints: 3)

# You can see all requests in the `Request.registry`

client.response.each_with_object({finished: 0 }) do |message, acc|
  message.termination? ? acc[:finished] += 1 : puts(message)
  break if acc[:finished] == 3
end
=>
#<Dtn::Messages::Interval request_id=1, timestamp=Fri, 11 Jun 2021 18:00:00 +0000, high=127.28, low=127.2, open=127.22, close=127.26, total_volume=53402051, period_volume=40382, number_of_trades=0>
#<Dtn::Messages::Interval request_id=1, timestamp=Fri, 11 Jun 2021 19:00:00 +0000, high=127.29, low=127.2, open=127.27, close=127.26, total_volume=53441647, period_volume=35228, number_of_trades=0>
#<Dtn::Messages::Interval request_id=1, timestamp=Fri, 11 Jun 2021 20:00:00 +0000, high=127.4, low=127.2599, open=127.26, close=127.4, total_volume=53522373, period_volume=73615, number_of_trades=0>
#<Dtn::Messages::Interval request_id=2, timestamp=Fri, 11 Jun 2021 18:00:00 +0000, high=331.26, low=331.12, open=331.26, close=331.12, total_volume=13583725, period_volume=940, number_of_trades=0>
#<Dtn::Messages::Interval request_id=2, timestamp=Fri, 11 Jun 2021 19:00:00 +0000, high=331.33, low=331.26, open=331.26, close=331.26, total_volume=13585069, period_volume=586, number_of_trades=0>
#<Dtn::Messages::Interval request_id=2, timestamp=Fri, 11 Jun 2021 20:00:00 +0000, high=331.4, low=331.26, open=331.26, close=331.4, total_volume=13587916, period_volume=1906, number_of_trades=0>
#<Dtn::Messages::Interval request_id=3, timestamp=Fri, 11 Jun 2021 18:00:00 +0000, high=257.7, low=257.55, open=257.65, close=257.7, total_volume=18994753, period_volume=4127, number_of_trades=0>
#<Dtn::Messages::Interval request_id=3, timestamp=Fri, 11 Jun 2021 19:00:00 +0000, high=257.7, low=257.57, open=257.7, close=257.7, total_volume=18996645, period_volume=1100, number_of_trades=0>
#<Dtn::Messages::Interval request_id=3, timestamp=Fri, 11 Jun 2021 20:00:00 +0000, high=257.7, low=257.61, open=257.61, close=257.65, total_volume=18999612, period_volume=1785, number_of_trades=0>

client.stop
```

Keep in mind, that with this approach client thread will require manual stop.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bundle exec rake` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

Test specs are using recorded output from DTN client. The recorded file is set
by the RSpec option `socket_recorder`, so you can share 1 recording with a few
specs. If the file is missing, then specs will do actual request to the api.
`socket_recorder` will use the pre-defined Date for the specs from the file
[current_day](https://github.com/kvokka/dtn/blob/master/spec/current_day) to
minimise recording rewrites. To bump the date to the yesterday business day
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
