[![CircleCI](https://circleci.com/gh/kvokka/dtn.svg?style=svg&circle-token=ed32de8a1360f1100f4601ee6d7311fd2b310220)](https://circleci.com/gh/kvokka/dtn)
[![Gem Version](https://img.shields.io/gem/v/dtn.svg)](https://rubygems.org/gems/dtn)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)
[![Maintainability](https://api.codeclimate.com/v1/badges/7bf62332c4d163460678/maintainability)](https://codeclimate.com/github/kvokka/dtn/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7bf62332c4d163460678/test_coverage)](https://codeclimate.com/github/kvokka/dtn/test_coverage)

# Dtn

Unofficial DTN (IQFeed) client.

# Dependencies

* IQFeed client ~> 6.1

# IQFeed API support status

## Streaming clients

- [x] Quote (Level 1) client
- [x] Level 2 client
- [x] Bar (Derivative) client
- [x] Admin client

## Lookup client

- [x] Historical data
- [x] News data
- [x] Symbol Lookup data
- [ ] Chains Lookup data
- [ ] Market Summary Data (new in protocol 6.1)

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
Dtn::Lookups::Historical::DailyTimeframe.call(
    symbol: :aapl,
    begin_date: Date.new(2021, 5, 1),
    end_date: Date.new(2021, 6, 1)
    )

=>
#<Dtn::Messages::Historical::DailyWeeklyMonthly request_id=1, timestamp=Mon, 03 May 2021 18:06:37 +0000, high=134.07, low=131.83, open=132.04, close=132.54, period_volume=75135100, open_interest=0>
#<Dtn::Messages::Historical::DailyWeeklyMonthly request_id=1, timestamp=Tue, 04 May 2021 18:06:37 +0000, high=131.4899, low=126.7, open=131.19, close=127.85, period_volume=137564718, open_interest=0>
#<Dtn::Messages::Historical::DailyWeeklyMonthly request_id=1, timestamp=Wed, 05 May 2021 18:06:37 +0000, high=130.45, low=127.97, open=129.2, close=128.1, period_volume=84000900, open_interest=0>
#<Dtn::Messages::Historical::DailyWeeklyMonthly request_id=1, timestamp=Thu, 06 May 2021 18:06:37 +0000, high=129.75, low=127.13, open=127.89, close=129.74, period_volume=78128334, open_interest=0>
...

# if block provided, then each message will be yielded as it is processed

Dtn::Lookups::News::Headline.call(limit: 10) do |message|
  # ...
end
```

### Supported requests

Keep in mind, that at the time of writing DTN, API has limit of 50
historical requests per minute.

TODO: Attach [limiter](https://github.com/Shopify/limiter) gem after merge
https://github.com/Shopify/limiter/pull/17 https://github.com/Shopify/limiter/pull/19
or use own branch of this gem.

#### News

* [config](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/news/config.rb)
```ruby
Dtn::Lookups::News::Config.call
```
* [headline](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/news/headline.rb)
```ruby
Dtn::Lookups::News::Headline.call limit: 10, symbols: 'aapl;fb'
```
* [story_count](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/news/story_count.rb)
```ruby
Dtn::Lookups::News::StoryCount.call symbols: :aapl, date_range: Date.new(2020,1,1)..Date.new(2020,2,1)
```
* [story](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/news/story.rb)
```ruby
Dtn::Lookups::News::Story.call story_id: '22424363689'
```


NOTES:

* if XML output option selected, the response will return **unparsed** XML

#### Historical

* [interval_day](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/interval_day.rb)
```ruby
Dtn::Lookups::Historical::IntervalDay.call(symbol: :aapl, interval: 3600, max_datapoints: 50, days: 2)
```
* [tick_timeframe](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/tick_timeframe.rb)
```ruby
Dtn::Lookups::Historical::TickTimeframe.call(
              symbol: :aapl,
              begin_datetime: begin_datetime,
              end_datetime: end_datetime,
              max_datapoints: 50
            )
```
* [daily_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/daily_datapoint.rb)
```ruby
Dtn::Lookups::Historical::DailyDatapoint.call(symbol: :aapl, max_datapoints: 50)
```
* [interval_timeframe](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/interval_timeframe.rb)
```ruby
Dtn::Lookups::Historical::IntervalTimeframe.call(
              symbol: :aapl,
              interval: 15,
              max_datapoints: 50,
              begin_datetime: DateTime.new(2020, 5, 1),
              end_datetime: DateTime.new(2020, 6, 1)
            )
```
* [tick_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/tick_datapoint.rb)
```ruby
Dtn::Lookups::Historical::TickDatapoint.call(symbol: :aapl, max_datapoints: 100)
```
* [weekly_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/weekly_datapoint.rb)
```ruby
Dtn::Lookups::Historical::WeeklyDatapoint.call(symbol: :aapl, max_datapoints: 10)
```
* [daily_timeframe](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/daily_timeframe.rb)
```ruby
Dtn::Lookups::Historical::DailyTimeframe.call(
              symbol: :aapl,
              begin_date: Date.new(2020, 5, 1),
              end_date: Date.new(2020, 6, 1)
            )
```
* [interval_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/interval_datapoint.rb)
```ruby
Dtn::Lookups::Historical::IntervalDatapoint.call(symbol: :aapl, interval: 3600, max_datapoints: 100)
```
* [monthly_datapoint](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/monthly_datapoint.rb)
```ruby
Dtn::Lookups::Historical::MonthlyDatapoint.call(symbol: :aapl, max_datapoints: 10)
```
* [tick_day](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/historical/tick_day.rb)
```ruby
Dtn::Lookups::Historical::TickDay.call(symbol: :aapl, days: 2, max_datapoints: 50)
```

NOTES:

* Lookups have extra options from their parents classes. They have appropriate
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
Dtn::Lookups::Symbol::BySic.call(search_line: '42')
```
* [by_naic](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/symbol/by_naic.rb)
```ruby
Dtn::Lookups::Symbol::ByNaic.call(search_line: '42')
```
* [by_filter](https://github.com/kvokka/dtn/blob/master/lib/dtn/requests/symbol/by_filter.rb)
```ruby
Dtn::Lookups::Symbol::ByFilter.call(field_to_search: "s", search_line: "aap", filter_type: "t", filter_value: "1")
```

#### Streaming data

All streaming data is using Observer pattern, so you can connect a few listeners
to any client with minimal cost. Below, you will get the examples with simple
observers, but there is an [Observer](https://github.com/kvokka/dtn/blob/master/lib/dtn/streaming/messages_recorder_observer.rb) for easier development & testing.

##### Quotes (Level1)

Streaming data is using Observers to deliver the results.
Keep in mind, that observers will receive data until you unsubscribe from it
or stop the client.

Summary message always come with all the possible fields, while for Update message
it is possible to add a filter with `client.request.quote.update_fields list: %w[Bid Ask]`

These methods do not allow any historical data access, only real time.

```ruby
class Observer
  # data callbacks are optional and match message class
  def level1_summary(message:)
    puts message
  end

  def level1_update(message:)
    puts message
  end

  # one of system methods callback
  def disconnected(message:)
    puts message
  end
end

client = Dtn::Streaming::Clients::Quote.new
client.observers << Observer.new
client.request.quote.watch symbol: :aapl
sleep 10
client.stop
```

[Here](https://github.com/kvokka/dtn/tree/master/lib/dtn/streaming/requests) you
will find all level1 streaming requests with appropriate documentation.

#### Bars data

Get live data as interval bar data. It allows to look back and fetch historical
data and get current (live) data as well,
[details](https://github.com/kvokka/dtn/tree/master/lib/dtn/streaming/requests/bar)

```ruby
class Observer
  # this callback will return all historical bars for the symbol
  def historical_bar(message:)
    puts message
  end

  # Here you get live updates until the current bar is formed
  def update_bar(message:)
    puts message
  end

  # when the current bar was formed, it will be processed by this callback
  def current_bar(message:)
    puts message
  end
end

client = Dtn::Streaming::Clients::Bar.new
client.observers << Observer.new
client.request.bar.watch symbol: :aapl
sleep 10
client.stop
```

#### Admin

Admin data management. See other commands in [here](https://github.com/kvokka/dtn/tree/master/lib/dtn/streaming/requests/admin)

```ruby
client.observers << Observer.new
client.request.admin.set_client_stats turned_on: false
```

#### Level2

Connection to level2 data. See other commands in [here](https://github.com/kvokka/dtn/tree/master/lib/dtn/streaming/requests/level2)

```ruby
client.observers << Observer.new
client.request.level2.watch symbol: :aapl
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

To run windows DTN client you can use the `docker-compose up` (before execution
pls fill in `.env` file with your credentials following the pattern from
[.env.example](https://github.com/kvokka/dtn/blob/master/.env.example))

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kvokka/dtn. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/kvokka/dtn/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dtn project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kvokka/dtn/blob/master/CODE_OF_CONDUCT.md).

## References

* https://github.com/mathpaquette/IQFeed.CSharpApiClient
* https://github.com/akapur/pyiqfeed
